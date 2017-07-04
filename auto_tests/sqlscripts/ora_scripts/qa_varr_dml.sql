REM -----------------------------------------------------------------------
REM Filename:     qa_varr_dml.sql
REM Purpose:      create tables with obj and scal Varray cols
REM Dependencies: qa_sql package
REM
REM Date:         11/23/13
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
   
   qa_sql.g_output := 'R';
   qa_sql.random_flag := FALSE;

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_VARR_SCAL_TYPE_1 AS VARRAY(5) OF VARCHAR2(10)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_VARR_SCAL_TYPE_2 AS VARRAY(7) OF CHAR(10)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_VARR_SCAL_TYPE_3 AS VARRAY(10) OF DATE',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_VARR_SCAL_TYPE_4 AS VARRAY(15) OF NUMBER',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_VARR_SCAL_TYPE_5 AS VARRAY(9) OF CHAR(15)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_VARR_SCAL_TYPE_6 AS VARRAY(8) OF DATE',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_VARR_SCAL_TYPE_7 AS VARRAY(6) OF NUMBER(11)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_VARR_SCAL_TYPE_8 AS VARRAY(4) OF VARCHAR2(8)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_UDT_OBJ_TYPE_1 AS OBJECT (C1 NUMBER(15))',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_UDT_OBJ_TYPE_2 AS OBJECT (C1 NUMBER,C2 VARCHAR2(10))',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_UDT_OBJ_TYPE_3 AS OBJECT (C1 DATE,C2 CHAR(5),C3 INTEGER)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_UDT_OBJ_TYPE_4 AS OBJECT (C1 NUMBER,C2 VARCHAR2(10),C3 DATE,C4 INTEGER)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_UDT_OBJ_TYPE_5 AS OBJECT (C1 CHAR(1),C2 NUMBER(4),C3 VARCHAR2(20),C4 FLOAT(5),C5 DATE)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_UDT_OBJ_TYPE_6 AS OBJECT (C1 FLOAT(7),C2 VARCHAR2(15),C3 NUMBER(7),C4 CHAR(10),C5 DATE ,C7 INTEGER)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_UDT_OBJ_TYPE_7 AS OBJECT (C1 NUMBER,C2 CHAR(3),C3 FLOAT(4),C4 VARCHAR2(5),C5 FLOAT(7),C6 DATE,C7 INTEGER,C8 DATE)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_UDT_OBJ_TYPE_8 AS OBJECT (C1 DATE,C2 FLOAT(21),C3 INTEGER,C4 CHAR(13),C5 VARCHAR2(9),C6 NUMBER(17),C7 CHAR(10),C8 DATE,C9 NUMBER)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );


-----------------------------------------------------------------------------------------

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_VARR_OBJ_TYPE_1 AS VARRAY(25) OF QA_UDT_OBJ_TYPE_1',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_VARR_OBJ_TYPE_2 AS VARRAY(20) OF QA_UDT_OBJ_TYPE_2',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_VARR_OBJ_TYPE_3 AS VARRAY(15) OF QA_UDT_OBJ_TYPE_3',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_VARR_OBJ_TYPE_4 AS VARRAY(10) OF QA_UDT_OBJ_TYPE_4',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_VARR_OBJ_TYPE_5 AS VARRAY(9) OF QA_UDT_OBJ_TYPE_5',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_VARR_OBJ_TYPE_6 AS VARRAY(8) OF QA_UDT_OBJ_TYPE_6',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_VARR_OBJ_TYPE_7 AS VARRAY(6) OF QA_UDT_OBJ_TYPE_7',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'CREATE TYPE QA_VARR_OBJ_TYPE_8 AS VARRAY(5) OF QA_UDT_OBJ_TYPE_8',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

   qa_sql.stor_table := qa_sql.stortab
                 (
                  'QA_VARR_OBJ_TYPE_1',
                  'number',
                  'QA_VARR_OBJ_TYPE_6',
                  'raw|30',
                  'QA_VARR_SCAL_TYPE_1',
                  'number|38',
                  'QA_VARR_OBJ_TYPE_7',
                  'rowid',
                  'QA_VARR_SCAL_TYPE_2',
                  'char|1000',
                  'QA_VARR_OBJ_TYPE_4',
                  'timestamp|9',
                  'QA_VARR_SCAL_TYPE_3',
                  'date',
                  'QA_VARR_OBJ_TYPE_5',
                  'varchar2|20',
                  'QA_VARR_SCAL_TYPE_8',
                  'integer',
                  'QA_VARR_SCAL_TYPE_6',
                  'raw|30',
                  'QA_VARR_SCAL_TYPE_7',
                  'rowid',
                  'QA_VARR_OBJ_TYPE_2',
                  'char|1000',
                  'QA_VARR_SCAL_TYPE_4',
                  'timestamp|9',
                  'QA_VARR_OBJ_TYPE_3',
                  'date',
                  'QA_VARR_SCAL_TYPE_5',
                  'varchar2|20',
                  'QA_VARR_OBJ_TYPE_8',
                  'integer',
                  'QA_VARR_OBJ_TYPE_2'
                 );

     qa_sql.create_tab
      (
      p_tabname      => 'qa_VARR_tab_1',
      p_colname      => 'COL',
      p_colnum       =>  5,
      p_pknum        =>  5,
      p_start        =>  1,
      p_varr_max     =>  2,
      --p_column       =>  'PRIMARY KEY(COL2.C1,COL3.C1,COL4,COL5)', 
      p_clause       =>  ' '
      );

    qa_sql.create_tab
      (
      p_tabname      => 'QA_VARR_TAB_2',
      p_colname      => 'col',
      p_colnum       =>  30,
      p_pknum        =>  5,
      p_start        =>  4,
      p_varr_max     =>  4,
      --p_column       =>  'PRIMARY KEY("col4","col5","col6".C1,"col8","col7".C1,"col10")', 
      p_clause       =>  ' '
      );

    qa_sql.create_tab
      (
      p_tabname      => 'Qa_VArr_Tab_3',
      p_colname      => 'CoL',
      p_colnum       =>  70,
      p_pknum        =>  11,
      p_start        =>  12,
      --p_column       =>  'PRIMARY KEY("CoL6".C1,"CoL7".C1,"CoL8","CoL9".C1,"CoL11")',  
      p_clause       =>  ' '
      );

    qa_sql.create_tab
      (
      p_tabname      => 'QA_VARR_TAB_GhVSWq27Jk_4',
      p_colname      => 'col_14Atesh45jMvLo86EWql_',
      p_colnum       =>  90,
      p_pknum        =>  14,
      p_start        =>  12,
      p_varr_max     =>  6,
      p_clause       =>  ' '
      );

    qa_sql.create_tab
      (
      p_tabname      => 'QA_VARR_TAB_5',
      p_colname      => 'COL',
      p_colnum       =>  170,
      p_pknum        =>  31,
      p_start        =>  15,
      p_varr_max     =>  7,
      p_clause       =>  ' ' 
      );

    qa_sql.create_tab
      (
      p_tabname      => 'QA_VARR_TAB_6',
      p_colname      => 'coL',
      p_colnum       =>  280,
      p_pknum        =>  5,
      p_start        =>  20,
      p_varr_max     =>  8,
      p_clause       =>  ' '
      );

END;
/

SET heading on
SET feedback on
SET verify on


