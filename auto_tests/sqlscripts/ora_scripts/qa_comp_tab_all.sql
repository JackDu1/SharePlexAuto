REM -----------------------------------------------------------------------
REM Filename:   qa_comp_tab_all.sql
REM Purpose:    compare all data
REM
REM Date:       03/22/06
REM Author:     Ilya Rubizhevsky
REM -----------------------------------------------------------------------

SET serveroutput on size 1000000
SET verify off
SET linesize 132
SET pagesize 10000
SET feedback off
SET heading off


DEFINE p_table_name='QA'
DEFINE p_service_name='&4'
DEFINE p_user_name='&3'

SET SERVEROUTPUT ON SIZE 1000000
SET VERIFY OFF

DECLARE
   TYPE columns_tp IS TABLE OF user_tab_columns%ROWTYPE
      INDEX BY BINARY_INTEGER;

   l_columns            columns_tp;
   l_table_name         VARCHAR2(50);
   l_select_list        LONG;
   l_query              LONG;
   l_index              BINARY_INTEGER;
   l_skip               BINARY_INTEGER;
   l_cnt1               BINARY_INTEGER;
   l_cnt2               BINARY_INTEGER;
   cannot_compare_udt   EXCEPTION;
   PRAGMA EXCEPTION_INIT (cannot_compare_udt, -22804);
BEGIN
   DBMS_OUTPUT.put_line (   RPAD ('Status', 10)
                         || RPAD ('Table Name', 35)
                         || 'Result'
                        );
   DBMS_OUTPUT.put_line (RPAD ('-', 70, '-'));

   --
   -- Iterate through all tables in the local database that match the
   -- specified table criteria.
   --
   FOR r1 IN (SELECT   '"' || table_name || '"' table_name
                  FROM user_tables
                 WHERE UPPER (table_name) LIKE '&&p_table_name%'
              ORDER BY 1)
   LOOP
      --
      -- Build a list of columns that we will compare - will skip columns
      -- with unsupported datatypes (BLOB,CLOB,NCLOB,LONG,LONG RAW,BFILE,XMLTYPE,GEOMETRY,UDT and Varrays).
      --
      l_table_name := RPAD (r1.table_name, 35);
      l_select_list := NULL;
      l_skip := 0;

      SELECT   *
      BULK COLLECT INTO l_columns
          FROM user_tab_columns
         WHERE '"' || table_name || '"' = r1.table_name
      ORDER BY column_id;

      FOR i IN 1 .. l_columns.COUNT
      LOOP
         IF l_columns (i).data_type IN
                      ('BLOB', 'CLOB', 'NCLOB', 'LONG', 'LONG RAW', 'BFILE', 'XMLTYPE')
            OR l_columns (i).data_type LIKE ('%UDT%')
            OR l_columns (i).data_type LIKE ('%SCAL%')
            OR l_columns (i).data_type LIKE ('%OBJ%')
            OR l_columns (i).data_type LIKE ('%ANYDATA%')
            OR l_columns (i).data_type LIKE ('%GEOMETRY%')
         THEN
            --not supported datatypes
            l_skip := l_skip + 1;
         ELSE
            IF l_select_list IS NULL
            THEN
               l_select_list := '"' || l_columns (i).column_name || '"';
            ELSE
               l_select_list :=
                      l_select_list
                   || ', '
                   || '"'
                   || l_columns (i).column_name
                   || '"';
            END IF;
         END IF;
      END LOOP;

      BEGIN
         l_query :=
                'SELECT COUNT(*) FROM ('
             || 'SELECT '
             || l_select_list
             || ' FROM '
             || r1.table_name
             || ' MINUS '
             || 'SELECT '
             || l_select_list
             || ' FROM '
             || '&&p_user_name'
             || '.'
             || r1.table_name
             || '@&&p_service_name)';
         EXECUTE IMMEDIATE l_query
            INTO l_cnt1;
         l_query :=
                'SELECT COUNT(*) FROM ('
             || 'SELECT '
             || l_select_list
             || ' FROM '
             || '&&p_user_name'
             || '.'
             || r1.table_name
             || '@&&p_service_name'
             || ' MINUS '
             || 'SELECT '
             || l_select_list
             || ' FROM '
             || r1.table_name
             || ')';
         EXECUTE IMMEDIATE l_query
            INTO l_cnt2;

         IF l_cnt1 = 0 AND l_cnt2 = 0
         THEN
            --
            -- No data discrepencies were found. 
            --
            DBMS_OUTPUT.put_line (   RPAD ('Passed::', 10)
                                  || l_table_name
                                  || 'The same data'
                                 );

            IF l_skip >= 1
            THEN
               DBMS_OUTPUT.put_line (   RPAD ('Warning', 10)
                                     || l_table_name
                                     || TO_CHAR (l_skip)
                                     || ' unsupported col(s) were skipped'
                                    );
            END IF;
         ELSE
            --
            -- There is a discrepency between the data in the local table and
            -- the remote table. 
            --
            IF l_cnt1 > 0
            THEN
               DBMS_OUTPUT.put_line (   RPAD ('Failed::', 10)
                                     || l_table_name
                                     || LTRIM (TO_CHAR (l_cnt1, '999,999,990'))
                                     || ' recs IN Src, NOT Trg'
                                    );
            END IF;

            IF l_cnt2 > 0
            THEN
               DBMS_OUTPUT.put_line (   RPAD ('Failed::', 10)
                                     || l_table_name
                                     || LTRIM (TO_CHAR (l_cnt2, '999,999,990'))
                                     || ' recs IN Trg, NOT SRC'
                                    );
            END IF;

            IF l_skip >= 1
            THEN
               DBMS_OUTPUT.put_line (   RPAD ('Warning::', 10)
                                     || l_table_name
                                     || TO_CHAR (l_skip)
                                     || ' unsupported col(s) were skipped'
                                    );
            END IF;
         END IF;
      EXCEPTION
         WHEN cannot_compare_udt
         THEN
            --
            -- An error occurred while processing UDT.
            --
            DBMS_OUTPUT.put_line (   RPAD ('Skipped::', 10)
                                  || l_table_name
                                  || ' NOT ABLE to compare UDT'
                                 );
         WHEN OTHERS
         THEN
            --
            -- An error occurred while processing this table. 
            --
            DBMS_OUTPUT.put_line ('Error:: ' || r1.table_name || ' - '
                                  || SQLERRM
                                 );
      END;
   END LOOP;
END;
/

SET feedback on
SET verify on

