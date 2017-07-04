REM -----------------------------------------------------------------------
REM Filename:   dml_ddl_varr.sql
REM Purpose:    Create tables for varray testing
REM             
REM Date:       02/12/08
REM Author:     Ilya Rubijevsky
REM -----------------------------------------------------------------------

SET serveroutput on size 1000000
SET verify off
SET linesize 132
SET pagesize 10000
SET feedback off
SET heading off

 DECLARE

   l_cnt_tab    NUMBER  := 8; 
   l_cnt_type   NUMBER  := 30; 

 BEGIN

   qa_sql.g_output    := 'R';
   qa_sql.random_flag := FALSE;

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_1 as object (c1 varchar2(20),c2 date,c3 number(12),c4 char(10))',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_2 as object (c1 char(2),c2 date,c3 number(5),c4 date)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_3 as object (c1 date,c2 number(11),c3 varchar2(38),c4 char(5))',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_4 as object (c1 char(10),c2 date,c3 number(11))',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_5 as object (c1 date,c2 number(5),c3 varchar2(4))',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_6 as object (c1 char(12),c2 number(11),c3 date)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_7 as object (c1 number(15),c2 date)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_8 as object (c1 date,c2 number(5))',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_9 as object (c1 varchar2(10))',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_10 as object (c1 char(7))',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

--------------------------------------------------------------------------

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_type_1 as VARRAY(1) of qa_varr_obj_1',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_type_2 as VARRAY(9) of qa_varr_obj_2',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_type_3 as VARRAY(12) of qa_varr_obj_3',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_type_4 as VARRAY(24) of qa_varr_obj_4',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_type_5 as VARRAY(49) of qa_varr_obj_5',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_type_6 as VARRAY(99) of qa_varr_obj_6',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_type_7 as VARRAY(149) of qa_varr_obj_7',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_type_8 as VARRAY(249) of qa_varr_obj_8',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_type_9 as VARRAY(499) of qa_varr_obj_9',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_obj_type_10 as VARRAY(499) of qa_varr_obj_10',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

-----------------------------------------------------------------------------------------

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_scal_type_1 as VARRAY(5) of CHAR(20)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_scal_type_2 as VARRAY(11) of VARCHAR(100)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_scal_type_3 as VARRAY(22) of NUMBER(22)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_scal_type_4 as VARRAY(39) of DATE',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_scal_type_5 as VARRAY(55) of CHAR(100)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_scal_type_6 as VARRAY(111) of NUMBER(8)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_scal_type_7 as VARRAY(149) of DATE',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_scal_type_8 as VARRAY(499) of CHAR(5)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_scal_type_9 as VARRAY(649) of VARCHAR2(10)',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => 'create type qa_varr_scal_type_10 as VARRAY(999) of NUMBER',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

--------------------------------------------------------------------------------

     qa_sql.exec_ddl
      (
      p_ddl_string    => '
CREATE TABLE QA_VARR_TAB_1 (
   ID      NUMBER   CONSTRAINT PK_QA_VARR_TAB1_ID  PRIMARY KEY
  ,ID1     NUMBER,  CONSTRAINT UK_QA_VARR_TAB1_ID1 UNIQUE (ID1)
  ,COL1    VARCHAR2(20)
  ,COL2    CHAR(10)
  ,COL3    DATE
  ,COL4    QA_VARR_SCAL_TYPE_1
  ,COL5    NUMBER(12)
  ,COL6    QA_VARR_OBJ_TYPE_3
  ,COL7    NUMBER
  ,COL8    QA_VARR_OBJ_TYPE_2
  ,COL9    VARCHAR2(50)
  ,COL10   DATE
  ,COL11   CHAR(1)
  ,COL12   FLOAT(5)
  ,COL13   DATE
  ,COL14   QA_VARR_SCAL_TYPE_5
  ,COL15   VARCHAR2(30)
)
                         ',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => '
CREATE TABLE QA_VARR_TAB_2 (
   ID      NUMBER   CONSTRAINT PK_QA_VARR_TAB2_ID  PRIMARY KEY
  ,ID1     NUMBER,  CONSTRAINT UK_QA_VARR_TAB2_ID1 UNIQUE (ID1)
  ,COL1    QA_VARR_SCAL_TYPE_2
  ,COL2    NUMBER
  ,COL3    QA_VARR_SCAL_TYPE_3
  ,COL4    DATE
  ,COL5    FLOAT(5)
  ,COL6    QA_VARR_OBJ_TYPE_1
  ,COL7    QA_VARR_SCAL_TYPE_4
  ,COL8    NUMBER
  ,COL9    CHAR(5)
  ,COL10   QA_VARR_OBJ_TYPE_3
  ,COL11   VARCHAR2(10)
  ,COL12   CHAR(25)
  ,COL13   DATE
  ,COL14   FLOAT(7)
  ,COL15   NUMBER(12)
  ,COL16   QA_VARR_OBJ_TYPE_4
  ,COL17   NUMBER
  ,COL18   DATE
  ,COL19   VARCHAR2(300)
  ,COL20   FLOAT(5)
)
                         ',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

--enable/disable storage in row 
     qa_sql.exec_ddl
      (
      p_ddl_string    => '
CREATE TABLE QA_VARR_TAB_3 (
   ID      NUMBER   CONSTRAINT PK_QA_VARR_TAB3_ID  PRIMARY KEY
  ,ID1     NUMBER,  CONSTRAINT UK_QA_VARR_TAB3_ID1 UNIQUE (ID1)
  ,COL1    VARCHAR2(1000)
  ,COL2    DATE
  ,COL3    QA_VARR_SCAL_TYPE_5
  ,COL4    QA_VARR_SCAL_TYPE_6
  ,COL5    CHAR(4)
  ,COL6    NUMBER
  ,COL7    FLOAT(9)
  ,COL8    QA_VARR_OBJ_TYPE_8
  ,COL9    NUMBER(8)
  ,COL10   DATE
)
VARRAY COL3 STORE AS LOB COL3_TAB3
(DISABLE STORAGE IN ROW PCTVERSION 100)
VARRAY COL4 STORE AS LOB COL4_TAB3
(ENABLE STORAGE IN ROW PCTVERSION 100)
VARRAY COL8 STORE AS LOB COL8_TAB3
(DISABLE STORAGE IN ROW PCTVERSION 100)
                         ',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => '
CREATE TABLE QA_VARR_TAB_4 (
   ID      NUMBER   CONSTRAINT PK_QA_VARR_TAB4_ID  PRIMARY KEY
  ,ID1     NUMBER,  CONSTRAINT UK_QA_VARR_TAB4_ID1 UNIQUE (ID1)
  ,COL1    VARCHAR2(30)
  ,COL2    CHAR(100)
  ,COL3    DATE
  ,COL4    QA_VARR_SCAL_TYPE_9
  ,COL5    FLOAT(7)
  ,COL6    DATE
  ,COL7    NUMBER
  ,COL8    CHAR(50)
  ,COL9    VARCHAR2(20)
  ,COL10   QA_VARR_OBJ_TYPE_7
  ,COL11   FLOAT(7)
  ,COL12   DATE
  ,COL13   NUMBER
  ,COL14   CHAR(50)
  ,COL15   VARCHAR2(20)
)
VARRAY COL4 STORE AS LOB COL4_TAB4
(DISABLE STORAGE IN ROW PCTVERSION 100)
VARRAY COL10 STORE AS LOB COL10_TAB4
(ENABLE STORAGE IN ROW PCTVERSION 100)
                         ',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

--enable storage in row 
     qa_sql.exec_ddl
      (
      p_ddl_string    => '
CREATE TABLE QA_VARR_TAB_5 (
   ID      NUMBER   CONSTRAINT PK_QA_VARR_TAB5_ID  PRIMARY KEY
  ,ID1     NUMBER,  CONSTRAINT UK_QA_VARR_TAB5_ID1 UNIQUE (ID1)
  ,COL1    CHAR(3)
  ,COL2    DATE
  ,COL3    NUMBER
  ,COL4    FLOAT(9)
  ,COL5    CHAR(5)
  ,COL6    QA_VARR_SCAL_TYPE_10
  ,COL7    VARCHAR2(10)
  ,COL8    NUMBER(4)
  ,COL9    VARCHAR2(12)
  ,COL10   DATE
)
VARRAY COL6 STORE AS LOB COL6_TAB5
(ENABLE STORAGE IN ROW PCTVERSION 100)
                         ',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => '
CREATE TABLE QA_VARR_TAB_6 (
   ID      NUMBER   CONSTRAINT PK_QA_VARR_TAB6_ID  PRIMARY KEY
  ,ID1     NUMBER,  CONSTRAINT UK_QA_VARR_TAB6_ID1 UNIQUE (ID1)
  ,COL1    VARCHAR2(1000)
  ,COL2    DATE
  ,COL3    QA_VARR_SCAL_TYPE_8
  ,COL4    QA_VARR_SCAL_TYPE_7
  ,COL5    CHAR(4)
  ,COL6    NUMBER
  ,COL7    FLOAT(9)
  ,COL8    QA_VARR_OBJ_TYPE_6
  ,COL9    NUMBER(8)
  ,COL10   DATE
  ,COL11   VARCHAR2(10)
  ,COL12   CHAR(25)
  ,COL13   DATE
  ,COL14   FLOAT(7)
  ,COL15   NUMBER(12)
  ,COL16   QA_VARR_OBJ_TYPE_2
  ,COL17   NUMBER
  ,COL18   DATE
  ,COL19   VARCHAR2(300)
  ,COL20   FLOAT(5)
)
VARRAY COL3 STORE AS LOB COL3_TAB6
(ENABLE STORAGE IN ROW PCTVERSION 100)
VARRAY COL4 STORE AS LOB COL4_TAB6
(ENABLE STORAGE IN ROW PCTVERSION 100)
VARRAY COL8 STORE AS LOB COL8_TAB6
(ENABLE STORAGE IN ROW PCTVERSION 100)
VARRAY COL16 STORE AS LOB COL16_TAB6
(ENABLE STORAGE IN ROW PCTVERSION 100)
                         ',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

--disable storage in row 
     qa_sql.exec_ddl
      (
      p_ddl_string    => '
CREATE TABLE QA_VARR_TAB_7 (
   ID      NUMBER   CONSTRAINT PK_QA_VARR_TAB7_ID  PRIMARY KEY
  ,ID1     NUMBER,  CONSTRAINT UK_QA_VARR_TAB7_ID1 UNIQUE (ID1)
  ,COL1    VARCHAR2(30)
  ,COL2    CHAR(100)
  ,COL3    DATE
  ,COL4    DATE
  ,COL5    QA_VARR_OBJ_TYPE_10
  ,COL6    DATE
  ,COL7    NUMBER
  ,COL8    CHAR(50)
  ,COL9    VARCHAR2(20)
  ,COL10   FLOAT(5)
)
VARRAY COL5 STORE AS LOB COL5_TAB7
(DISABLE STORAGE IN ROW PCTVERSION 100)
                         ',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

     qa_sql.exec_ddl
      (
      p_ddl_string    => '
CREATE TABLE QA_VARR_TAB_8 (
   ID      NUMBER   CONSTRAINT PK_QA_VARR_TAB8_ID  PRIMARY KEY
  ,ID1     NUMBER,  CONSTRAINT UK_QA_VARR_TAB8_ID1 UNIQUE (ID1)
  ,COL1    CHAR(3)
  ,COL2    QA_VARR_OBJ_TYPE_9
  ,COL3    NUMBER
  ,COL4    FLOAT(9)
  ,COL5    QA_VARR_OBJ_TYPE_5
  ,COL6    QA_VARR_SCAL_TYPE_1
  ,COL7    VARCHAR2(10)
  ,COL8    NUMBER(4)
  ,COL9    VARCHAR2(12)
  ,COL10   FLOAT(8)
  ,COL11   QA_VARR_SCAL_TYPE_2
  ,COL12   CHAR(25)
  ,COL13   DATE
  ,COL14   FLOAT(7)
  ,COL15   NUMBER(12)
  ,COL16   VARCHAR2(40)
  ,COL17   NUMBER
  ,COL18   DATE
  ,COL19   DATE
  ,COL20   FLOAT(5)
)
VARRAY COL2 STORE AS LOB COL2_TAB8
(DISABLE STORAGE IN ROW PCTVERSION 100)
VARRAY COL5 STORE AS LOB COL5_TAB8
(DISABLE STORAGE IN ROW PCTVERSION 100)
VARRAY COL6 STORE AS LOB COL6_TAB8
(DISABLE STORAGE IN ROW PCTVERSION 100)
VARRAY COL11 STORE AS LOB COL11_TAB8
(DISABLE STORAGE IN ROW PCTVERSION 100)
                         ',
      p_ddl_type      => 'EXECUTE IMMEDIATE'
      );

   FOR x IN (SELECT count(object_name) cnt
               FROM user_objects
              WHERE object_type = 'TYPE')
   LOOP
       if x.cnt = l_cnt_type
       then
          DBMS_OUTPUT.put_line ('Passed:: Create QA_VARR_TYPE_X types');
       else
          DBMS_OUTPUT.put_line ('Failed:: Create QA_VARR_TYPE_X types');
       end if;

   END LOOP;

   FOR x IN (SELECT count(object_name) cnt
               FROM user_objects
              WHERE object_type = 'TABLE')
   LOOP
       if x.cnt = l_cnt_tab
       then
          DBMS_OUTPUT.put_line ('Passed:: Create QA_VARR_TAB_X tables');
       else
          DBMS_OUTPUT.put_line ('Failed:: Create QA_VARR_TAB_X tables');
       end if;

   END LOOP;

END;
/

SET heading on
SET feedback on
SET verify on

