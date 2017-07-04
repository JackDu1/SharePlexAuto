--for postgresql
--dzhu, 7/28/2016
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

----------------------------

DROP TABLE IF EXISTS "sp_pg".qa_date_lt1753;

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


----------------------------

DROP TABLE IF EXISTS "sp_pg".qa_timestamp;

CREATE TABLE "sp_pg".qa_timestamp
(
  COL_NUMBER       number(25,2),
  COL_TIMESTAMP1   timestamp(4) with time zone,
  COL_TIMESTAMP2   timestamp,
  COL_TIMESTAMP3   timestamp(3) with time zone,
  COL_TIMESTAMP4   timestamp(2),
  COL_TIMESTAMP5   timestamp(5) with time zone,
  COL_TIMESTAMP6   timestamp(6),
  COL_TIMESTAMP7   timestamp(6) with time zone,
  COL_TIMESTAMP8   timestamp(6),
  COL_TIMESTAMP9   timestamp(6) with time zone,
  COL_TIMESTAMP10  timestamp(6) with time zone
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
*/

DROP TABLE IF EXISTS "sp_pg".qa_float;

create table "sp_pg".qa_float
(
  COL_NUMBER  numeric(25,2) not null,
  COL_FLOAT1   float(10),
  COL_FLOAT2   float(15),
  COL_FLOAT3   float(20),
  COL_FLOAT4   float(25),
  COL_FLOAT5   float(28),
PRIMARY KEY(COL_NUMBER)
);

----------------------------

/*
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
*/

----------------------------

DROP TABLE IF EXISTS "sp_pg".qa_long;

create table "sp_pg".qa_long
(
  COL_NUMBER   numeric(25,2) not null,
  COL_LONG     text,
PRIMARY KEY(COL_NUMBER)
);

----------------------------

DROP TABLE IF EXISTS sp_pg."sp_pg".qa_raw;


CREATE TABLE sp_pg."sp_pg".qa_raw
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

DROP TABLE IF EXISTS "sp_pg".qa_all;

create table "sp_pg".qa_all
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CHAR   CHAR(2000),
  COL_VARCHAR2 VARCHAR(4000),
  COL_DATE_LT1753   datetime,
  COL_DATE_GT1753   datetime,
  COL_TIMESTAMP TIMESTAMP(6),
  COL_TIMESTAMP_TZ TIMESTAMP(6) WITH TIME ZONE,
  COL_FLOAT  FLOAT(30),
  COL_LONG   text,
--   COL_RAW    bytea(1000),
   COL_RAW    bytea,
  COL_CLOB_NULL   text,
  COL_CLOB_LT4K   text,
  COL_CLOB_GT4K   text,
  COL_CLOB_LTGT4K   text,
  COL_BLOB_NULL   bytea,
  COL_BLOB_LT4K   bytea,
  COL_BLOB_GT4K   bytea,
  COL_BLOB_LTGT4K   bytea
);

