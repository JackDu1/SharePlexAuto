REM -----------------------------------------------------------------------
REM Filename:     qa_udt_ins.sql 
REM Purpose:      insert data for UDT testing
REM Dependencies: qa_sql package
REM
REM Date:         03/01/13
REM Author:       Ilya Rubizhevsky
REM -----------------------------------------------------------------------

SET time on
SET timing on
SET serveroutput on size 1000000 format wrapped
SET verify off
SET linesize 132
SET pagesize 10000
SET feedback off
SET heading off

BEGIN
   
qa_sql.g_output         := 'E';
qa_sql.random_flag      := TRUE;
qa_sql.g_table_name     := 'QA';

   qa_sql.version;

   FOR rt IN (SELECT   tname 
                  FROM tab
                 WHERE UPPER (tname) LIKE qa_sql.g_table_name || '%'
              ORDER BY 1)
   LOOP

/*
      qa_sql.bulkdml
      (
      p_tab      => rt.tname,
      p_rows     => 100,
      p_ins      => 'd'
      );
*/

     qa_sql.iud
      (
      p_tab      => rt.tname,
      p_ins      => 300,
      p_upd      => 0,
      p_del      => 0,
      p_com      => 2,
      p_rol      => 0,
      p_noth     => 5,
      p_null     => 10,
      p_null_udt => 30,
      p_null_varr => 30,
      p_ins_flag => 'r',
      p_length   => 'm',
      p_prb      => FALSE
      );

     qa_sql.iud
      (
      p_tab      => rt.tname,
      p_ins      => 200,
      p_upd      => 0,
      p_del      => 0,
      p_com      => 2,
      p_rol      => 0,
      p_noth     => 5,
      p_null     => 10,
      p_null_udt => 30,
      p_null_varr => 30,
      p_ins_flag => 'd',
      p_length   => 'm',
      p_prb      => FALSE
      );

   END LOOP;
END;
/

SET heading on
SET feedback on
SET verify on



