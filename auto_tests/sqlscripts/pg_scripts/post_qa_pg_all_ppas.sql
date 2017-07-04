--for postgresql
--dzhu, 7/28/2016
REM ---------------------------------------------------------------------------------------------------------------
REM Modification: 12/4/2015 Julia modified from qa_pg_all.sql to remove time zone from timestamp and make sure no anydata, uncomment integer since it is supported in ppas (not sqlserver)
REM Modification: 2 tables are different qa_timestamp, qa_all, all anydata tables are not included
REM ---------------------------------------------------------------------------------------------------------------

-- 6-16-2016 Julia drop some old tables not in use anymore
DROP TABLE IF EXISTS "sp_pg".qa_all;
DROP TABLE IF EXISTS "sp_pg".qa_float;


DROP TABLE IF EXISTS "sp_pg".qa_char;

create table "sp_pg".qa_char
(
  COL_NUMBER numeric(25,2) not null,
  COL_CHAR1   char(100),
  COL_CHAR2   char(500),
  COL_CHAR3   char(1000),
  COL_CHAR4   char(1500),
  COL_CHAR5   char(2000),
PRIMARY KEY(COL_NUMBER)
);

----------------------------

DROP TABLE IF EXISTS "sp_pg".qa_varchar2;

create table "sp_pg".qa_varchar2
(
  COL_NUMBER       numeric(25,2) not null,
  COL_VARCHAR2_1   varchar(100),
  COL_VARCHAR2_2   varchar(500),
  COL_VARCHAR2_3   varchar(1000),
  COL_VARCHAR2_4   varchar(2000),
  COL_VARCHAR2_5   varchar(4000),
PRIMARY KEY(COL_NUMBER)
);

----------------------------

DROP TABLE IF EXISTS "sp_pg".qa_date_gt1753;

/*
create table "sp_pg".qa_date_gt1753
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DATE1   datetime,
  COL_DATE2   datetime,
  COL_DATE3   datetime,
  COL_DATE4   datetime,
  COL_DATE5   datetime,
PRIMARY KEY(COL_NUMBER)
);
*/

--2-1-2016 Julia change to date, target datatype map shows Oracle date map to PPAS date

create table "sp_pg".qa_date_gt1753
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DATE1   date,
  COL_DATE2   date,
  COL_DATE3   date,
  COL_DATE4   date,
  COL_DATE5   date,
PRIMARY KEY(COL_NUMBER)
);

----------------------------

DROP TABLE IF EXISTS "sp_pg".qa_date_lt1753;

/*
create table "sp_pg".qa_date_lt1753
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DATE1   datetime,
  COL_DATE2   datetime,
  COL_DATE3   datetime,
  COL_DATE4   datetime,
  COL_DATE5   datetime,
PRIMARY KEY(COL_NUMBER)
);
*/


--2-1-2016 Julia change to date, target datatype map shows Oracle date map to PPAS date

create table "sp_pg".qa_date_lt1753
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DATE1   date,
  COL_DATE2   date,
  COL_DATE3   date,
  COL_DATE4   date,
  COL_DATE5   date,
PRIMARY KEY(COL_NUMBER)
);


----------------------------

DROP TABLE IF EXISTS "sp_pg".qa_timestamp;

CREATE TABLE "sp_pg".qa_timestamp
(
--  COL_NUMBER       number(25,2),
  COL_NUMBER       numeric(25,2),
  COL_TIMESTAMP1   timestamp(4),
  COL_TIMESTAMP2   timestamp,
  COL_TIMESTAMP3   timestamp(3),
  COL_TIMESTAMP4   timestamp(2),
  COL_TIMESTAMP5   timestamp(5),
  COL_TIMESTAMP6   timestamp(6),
  COL_TIMESTAMP7   timestamp(6),
  COL_TIMESTAMP8   timestamp(6),
  COL_TIMESTAMP9   timestamp(6),
  COL_TIMESTAMP10  timestamp(6)
,
PRIMARY KEY(COL_NUMBER)
);


----------------------------

/*
DROP TABLE IF EXISTS "sp_pg".qa_number;

create table "sp_pg".qa_number
(
  COL_NUMBER    numeric(25,2) not null,
  COL_NUMBER1   numeric(12,2),
  COL_NUMBER2   numeric(18,3),
  COL_NUMBER3   numeric(25,4),
  COL_NUMBER4   numeric(30,5),
  COL_NUMBER5   numeric(38),
PRIMARY KEY(COL_NUMBER)
);
*/

DROP TABLE IF EXISTS "sp_pg".qa_number;

create table "sp_pg".qa_number
(
  COL_NUMBER    numeric(25,2) not null,
  COL_NUMBER1   numeric(20,7),
  COL_NUMBER2   numeric(24,4),
  COL_NUMBER3   numeric(26,2),
  COL_NUMBER4   numeric(27,1),
  COL_NUMBER5   numeric(28),
PRIMARY KEY(COL_NUMBER)
);

----------------------------

/*
DROP TABLE IF EXISTS "sp_pg".qa_float;

create table "sp_pg".qa_float
(
  COL_NUMBER  numeric(25,2) not null,
  COL_FLOAT1   float(10),
  COL_FLOAT2   float(20),
  COL_FLOAT3   float(40),
  COL_FLOAT4   float(50),
  COL_FLOAT5   float(53),
PRIMARY KEY(COL_NUMBER)
);

DROP TABLE IF EXISTS "sp_pg".qa_float;

create table "sp_pg".qa_float
(
  COL_NUMBER  numeric(25,2) not null,
  COL_FLOAT1   double precision,
  COL_FLOAT2   double precision,
  COL_FLOAT3   double precision,
  COL_FLOAT4   double precision,
  COL_FLOAT5   double precision,
PRIMARY KEY(COL_NUMBER)
);

*/
----------------------------

DROP TABLE IF EXISTS "sp_pg".qa_binary_float;

create table "sp_pg".qa_binary_float
(
  COL_NUMBER  numeric(25,2) not null,
  COL_FLOAT1   double precision,
  COL_FLOAT2   double precision,
  COL_FLOAT3   double precision,
  COL_FLOAT4   double precision,
  COL_FLOAT5   double precision,
PRIMARY KEY(COL_NUMBER)
);


----------------------------
DROP TABLE IF EXISTS "sp_pg".qa_binary_double;

create table "sp_pg".qa_binary_double
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DOUBLE1   double precision,
  COL_DOUBLE2   double precision,
  COL_DOUBLE3   double precision,
  COL_DOUBLE4   double precision,
  COL_DOUBLE5   double precision,
PRIMARY KEY(COL_NUMBER)
);


----------------------------

DROP TABLE IF EXISTS "sp_pg".qa_integer;

create table "sp_pg".qa_integer
(
  COL_NUMBER     numeric(25,2) not null,
  COL_INTEGER1   integer,
  COL_INTEGER2   int,
  COL_INTEGER3   integer,
  COL_INTEGER4   int,
  COL_INTEGER5   integer,
PRIMARY KEY(COL_NUMBER)
);


----------------------------

DROP TABLE IF EXISTS "sp_pg".qa_long;

create table "sp_pg".qa_long
(
  COL_NUMBER   numeric(25,2) not null,
  COL_LONG     text,
PRIMARY KEY(COL_NUMBER)
);

----------------------------

DROP TABLE IF EXISTS sp_pg.qa_raw;


CREATE TABLE sp_pg.qa_raw
(
  COL_NUMBER   numeric(25,2) not null,
--  COL_RAW1     bytea(200),
--  COL_RAW2     bytea(400),
--  COL_RAW3     bytea(1000),
--  COL_RAW4     bytea(3000),
--  COL_RAW5     bytea(4000),
  COL_RAW1     bytea,
  COL_RAW2     bytea,
  COL_RAW3     bytea,
  COL_RAW4     bytea,
  COL_RAW5     bytea,
PRIMARY KEY(COL_NUMBER)
);

----------------------------

DROP TABLE IF EXISTS "sp_pg".qa_long_raw;
create table "sp_pg".qa_long_raw
(
  COL_NUMBER      numeric(25,2) not null,
  COL_LONG_RAW    bytea,
PRIMARY KEY(COL_NUMBER)
);

-----------------------


DROP TABLE IF EXISTS "sp_pg".qa_clob_lt4k;

create table "sp_pg".qa_clob_lt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   text,
  COL_CLOB2   text,
  COL_CLOB3   text,
  COL_CLOB4   text,
  COL_CLOB5   text,
PRIMARY KEY(COL_NUMBER)
);


-----------------------

DROP TABLE IF EXISTS "sp_pg".qa_clob_lt32k;

create table "sp_pg".qa_clob_lt32k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   text,
  COL_CLOB2   text,
  COL_CLOB3   text,
  COL_CLOB4   text,
  COL_CLOB5   text,
PRIMARY KEY(COL_NUMBER)
);

-----------------------

DROP TABLE IF EXISTS "sp_pg".qa_clob_ltgt4k;

create table "sp_pg".qa_clob_ltgt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   text,
  COL_CLOB2   text,
  COL_CLOB3   text,
  COL_CLOB4   text,
  COL_CLOB5   text,
PRIMARY KEY(COL_NUMBER)
);

-----------------------

DROP TABLE IF EXISTS "sp_pg".qa_clob_gt4k;

create table "sp_pg".qa_clob_gt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   text,
  COL_CLOB2   text,
  COL_CLOB3   text,
  COL_CLOB4   text,
  COL_CLOB5   text,
PRIMARY KEY(COL_NUMBER)
);

-----------------------

DROP TABLE IF EXISTS sp_pg.qa_clob_null;

CREATE TABLE sp_pg.qa_clob_null
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   text,
  COL_CLOB2   text,
  COL_CLOB3   text,
  COL_CLOB4   text,
  COL_CLOB5   text,
PRIMARY KEY(COL_NUMBER)
);



-----------------------

/*
DROP TABLE IF EXISTS "sp_pg".qa_nclob_lt4k;

create table "sp_pg".qa_nclob_lt4k
(
  COL_NUMBER   numeric(25,2) not null,
  COL_NCLOB1   text,
  COL_NCLOB2   text,
  COL_NCLOB3   text,
  COL_NCLOB4   text,
  COL_NCLOB5   text,
PRIMARY KEY(COL_NUMBER)
);


-----------------------

DROP TABLE IF EXISTS "sp_pg".qa_nclob_lt32k;

create table "sp_pg".qa_nclob_lt32k
(
  COL_NUMBER   numeric(25,2) not null,
  COL_NCLOB1   text,
  "sp_pg".qa_pg_all.sqlCOL_NCLOB2   text,
  COL_NCLOB3   text,
  COL_NCLOB4   text,
  COL_NCLOB5   text,
PRIMARY KEY(COL_NUMBER)
);

-----------------------

DROP TABLE IF EXISTS "sp_pg".qa_nclob_ltgt4k;

create table "sp_pg".qa_nclob_ltgt4k
(
  COL_NUMBER   numeric(25,2) not null,
  COL_NCLOB1   text,
  COL_NCLOB2   text,
  COL_NCLOB3   text,
  COL_NCLOB4   text,
  COL_NCLOB5   text,
PRIMARY KEY(COL_NUMBER)
);
*/

-----------------------

DROP TABLE IF EXISTS "sp_pg".qa_blob_lt4k;

create table "sp_pg".qa_blob_lt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_BLOB1   bytea,
  COL_BLOB2   bytea,
  COL_BLOB3   bytea,
  COL_BLOB4   bytea,
  COL_BLOB5   bytea,
PRIMARY KEY(COL_NUMBER)
);

-----------------------

DROP TABLE IF EXISTS "sp_pg".qa_blob_lt32k;

create table "sp_pg".qa_blob_lt32k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_BLOB1   bytea,
  COL_BLOB2   bytea,
  COL_BLOB3   bytea,
  COL_BLOB4   bytea,
  COL_BLOB5   bytea,
PRIMARY KEY(COL_NUMBER)
);

-----------------------

DROP TABLE IF EXISTS "sp_pg".qa_blob_gt4k;

create table "sp_pg".qa_blob_gt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_BLOB1   bytea,
  COL_BLOB2   bytea,
  COL_BLOB3   bytea,
  COL_BLOB4   bytea,
  COL_BLOB5   bytea,
PRIMARY KEY(COL_NUMBER)
);

-----------------------

DROP TABLE IF EXISTS "sp_pg".qa_blob_ltgt4k;

create table "sp_pg".qa_blob_ltgt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_BLOB1   bytea,
  COL_BLOB2   bytea,
  COL_BLOB3   bytea,
  COL_BLOB4   bytea,
  COL_BLOB5   bytea,
PRIMARY KEY(COL_NUMBER)
);

-----------------------

DROP TABLE IF EXISTS sp_pg.qa_blob_null;

create table sp_pg.qa_blob_null
(
  COL_NUMBER  numeric(25,2) not null,
  COL_BLOB1   bytea,
  COL_BLOB2   bytea,
  COL_BLOB3   bytea,
  COL_BLOB4   bytea,
  COL_BLOB5   bytea,
PRIMARY KEY(COL_NUMBER)
);


-----------------------
--6-16-2016 Julia change to use table name qa_all_uk instead of qa_all, to be consistant with hana and alldb_all_suite
--drop qa_all_uk too since it's using the same constraints to avoid error  : name already used by an existing constraint
DROP TABLE IF EXISTS "sp_pg".qa_all_uk;
--DROP TABLE IF EXISTS "sp_pg".qa_all;

--12-11-2015 julia match qa_all table in qa_all_uk table to reuse dload and other scripts, remove NOT NULL on UK, ADD PK:w

create table "sp_pg".qa_all_uk
(
  COL_NUMBER  numeric(25,2) not null,
  -- COL_NUMBER_UK1 NUMBER(30) not null,
  COL_NUMBER_UK1 NUMERIC(30) not null,
  COL_CHAR_UK2 CHAR(200) not null,
  COL_TIMESTAMP_UK3 TIMESTAMP(6) not null,
  -- COL_VARCHAR2_UK4 VARCHAR2(400),
  COL_VARCHAR2_UK4 VARCHAR(400),
  COL_CHAR   CHAR(2000),
  COL_VARCHAR2 VARCHAR(4000),
  COL_DATE_LT1753   timestamp(6),
  COL_DATE_GT1753   timestamp(6),
  COL_TIMESTAMP timestamp(6),
  COL_TIMESTAMP_TZ timestamp(6),
  COL_FLOAT  FLOAT(30),
  COL_LONG   text,
--  COL_RAW    bytea(1000),
  COL_RAW    bytea,
  --COL_LONG_RAW LONG RAW,
  --COL_ANYDATA_CHAR sql_variant,
  --COL_ANYDATA_VARCHAR2 sql_variant,
  --COL_ANYDATA_NUMBER sql_variant,
  --COL_ANYDATA_DATE sql_variant,
  --COL_ANYDATA_TIMESTAMP sql_variant,
  --COL_ANYDATA_RAW bytea(2000),
  COL_CLOB_NULL   text,
  COL_CLOB_LT4K   text,
  COL_CLOB_GT4K   text,
  COL_CLOB_LTGT4K   text,
  COL_BLOB_NULL   bytea,
  COL_BLOB_LT4K   bytea,
  COL_BLOB_GT4K   bytea,
  COL_BLOB_LTGT4K   bytea,
PRIMARY KEY (COL_NUMBER),
CONSTRAINT "UK_QA_ALL_UK1" UNIQUE(COL_NUMBER_UK1),
CONSTRAINT "UK_QA_ALL_UK2" UNIQUE(COL_CHAR_UK2),
CONSTRAINT "UK_QA_ALL_UK3" UNIQUE(COL_TIMESTAMP_UK3,COL_VARCHAR2_UK4)
);

