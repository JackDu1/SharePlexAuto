REM -----------------------------------------------------------------------
REM Filename:   qa_analyze_tab.sql
REM Purpose:    analyze all tables
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

UNDEFINE p_table_name
DEFINE   p_table_name='QA'

BEGIN
   FOR tr IN (SELECT '"'||table_name||'"' table_name
                  FROM user_tables
                 WHERE upper(table_name) LIKE '&&p_table_name%'
                   AND table_name NOT LIKE 'SYS_IOT%'
              ORDER BY 1)
   LOOP
      --DBMS_OUTPUT.PUT_LINE ('analyze table '||tr.table_name||' delete statistics');
      --EXECUTE IMMEDIATE     'analyze table '||tr.table_name||' delete statistics';

      DBMS_OUTPUT.PUT_LINE ('analyze table '||tr.table_name||' compute statistics for table');
      EXECUTE IMMEDIATE     'analyze table '||tr.table_name||' compute statistics for table';
   END LOOP;

END;

/

SET heading on
SET feedback on
SET verify on
