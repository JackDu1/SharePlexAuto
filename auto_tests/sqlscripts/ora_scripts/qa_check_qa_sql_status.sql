REM -----------------------------------------------------------------------
REM Filename:   qa_check_qa_sql_status.sql
REM Purpose:    check package status
REM
REM Date:       01/22/08
REM Author:     Ilya Rubizhevsky
REM -----------------------------------------------------------------------

SET serveroutput on size 1000000
SET verify off
SET linesize 132
SET pagesize 10000
SET feedback off

UNDEFINE p_object_name
DEFINE   p_object_name='QA_SQL'

column result format a10 word_wrapped heading 'Result'
column object_type format a15 word_wrapped heading 'ObjType'
column object_name format a10 word_wrapped heading 'ObjName'
column status format a10 word_wrapped heading 'Status'

SELECT (CASE
           WHEN status = 'INVALID'
              THEN 'Failed::'
           WHEN status = 'VALID'
              THEN 'Passed::'
        END
       ) RESULT,
       object_type, object_name, status
  FROM user_objects
 WHERE object_name = '&&p_object_name';


SET feedback on
SET verify on

