REM -----------------------------------------------------------------------
REM Filename:   qa_create_db_link.sql
REM Purpose:    drop/create db link
REM
REM Date:       12/25/05
REM Author:     Ilya Rubizhevsky
REM -----------------------------------------------------------------------

SET serveroutput on size 1000000
SET verify off
SET linesize 132
SET pagesize 10000
SET feedback off
SET heading off

DEFINE p_usr='QARUN'
DEFINE p_service_name='&4'

DECLARE
   l_sql   LONG;

   PROCEDURE create_dblink (p_service_name IN VARCHAR2, p_usr IN VARCHAR2)
   IS
      l_cnt    INTEGER;
      l_service_name   VARCHAR2 (100) := UPPER (p_service_name);
   BEGIN
      BEGIN
         SELECT COUNT (*)
           INTO l_cnt
           FROM DUAL
          WHERE EXISTS (SELECT NULL
                          FROM all_db_links
                         WHERE db_link = l_service_name);

         IF (l_cnt = 1)
         THEN
            DBMS_OUTPUT.put_line ('Message:: public database link ' || l_service_name || ' exists...');
         END IF;

         IF (l_cnt = 0)
         THEN
            l_sql :=
                  'ALTER SESSION SET global_names = FALSE';
            DBMS_OUTPUT.put_line ('Execute -> ' || LOWER (l_sql));

            EXECUTE IMMEDIATE l_sql;

            l_sql :=
                  'CREATE PUBLIC DATABASE LINK '
               || l_service_name
               || ' CONNECT TO '
               || p_usr
               || ' IDENTIFIED BY '
               --|| LOWER(p_usr)
               || '"'||LOWER(p_usr) ||'"'
               || ' USING '
               || ''''
               || l_service_name
               || '''';
            DBMS_OUTPUT.put_line ('Execute -> ' || LOWER (l_sql));
            --DBMS_OUTPUT.put_line ('Execute -> ' || 'create public database link ' || lower(l_service_name));

            EXECUTE IMMEDIATE l_sql;

         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (l_sql);
            DBMS_OUTPUT.put_line (SQLERRM);
      END;
   END create_dblink;


   PROCEDURE drop_dblink (p_service_name IN VARCHAR2)
   IS
      l_wait    BOOLEAN       := FALSE;
      l_cnt     NUMBER        := 0;
      l_cnt_max NUMBER        := 20;
      l_service_name   VARCHAR2 (100) := UPPER (p_service_name);
   BEGIN
      WHILE (NOT l_wait AND NOT (l_cnt > l_cnt_max))
      LOOP
         BEGIN
            -- if OK, set l_wait = TRUE
            -- else EXCEPTION will automatically fire.
            FOR ot IN (SELECT   db_link
                           FROM all_db_links
                          WHERE db_link = l_service_name)
            LOOP
               l_sql := 'drop public database link ' || ot.db_link;
                IF (l_cnt = 0)
                THEN
                   DBMS_OUTPUT.put_line ('Execute -> ' || LOWER (l_sql));
                END IF; 
               EXECUTE IMMEDIATE l_sql;
            END LOOP;

            l_wait := TRUE;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_wait := FALSE;
               DBMS_LOCK.sleep (10);
               DBMS_OUTPUT.put_line
                                  ('Execute -> wait 10s');
               l_cnt := l_cnt + 1;
         END;
      END LOOP;

      --DBMS_OUTPUT.put_line ('Execute -> ' || LOWER (l_sql));

      FOR un IN (SELECT   db_link
                           FROM all_db_links
                          WHERE db_link = l_service_name)
      LOOP
         DBMS_OUTPUT.put_line (   'Failed:: database link '
                               || un.db_link
                               || ' still exists...'
                              );
      END LOOP;
   END drop_dblink;
BEGIN
   BEGIN

      --TODO should not drop dblink all the time - just check if exists
      drop_dblink   ('&&p_service_name');
      create_dblink ('&&p_service_name', '&&p_usr');

   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (l_sql);
         DBMS_OUTPUT.put_line (SQLERRM);
   END;
END;
/

SET heading on
SET feedback on
SET verify on


