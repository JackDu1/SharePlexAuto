use sp_ss
IF OBJECT_ID('sp_ss.qa_char', 'U') IS NOT NULL
drop table sp_ss.qa_char
go
create table sp_ss.qa_char
(
  COL_NUMBER numeric(25,2) not null,
  COL_CHAR1   char(100),
  COL_CHAR2   char(500),
  COL_CHAR3   char(1000),
  COL_CHAR4   char(1500),
  COL_CHAR5   char(2000),
PRIMARY KEY(COL_NUMBER)
)
go

----------------------------

IF OBJECT_ID('sp_ss.qa_varchar2', 'U') IS NOT NULL
drop table sp_ss.qa_varchar2
go
create table sp_ss.qa_varchar2
(
  COL_NUMBER       numeric(25,2) not null,
  COL_VARCHAR2_1   varchar(100),
  COL_VARCHAR2_2   varchar(500),
  COL_VARCHAR2_3   varchar(1000),
  COL_VARCHAR2_4   varchar(2000),
  COL_VARCHAR2_5   varchar(4000),
PRIMARY KEY(COL_NUMBER)
)
go

----------------------------

IF OBJECT_ID('sp_ss.qa_date_gt1753', 'U') IS NOT NULL
drop table sp_ss.qa_date_gt1753
go
create table sp_ss.qa_date_gt1753
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DATE1   datetime,
  COL_DATE2   datetime,
  COL_DATE3   datetime,
  COL_DATE4   datetime,
  COL_DATE5   datetime,
PRIMARY KEY(COL_NUMBER)
)
go

----------------------------

IF OBJECT_ID('sp_ss.qa_date_lt1753', 'U') IS NOT NULL
drop table sp_ss.qa_date_lt1753
go
create table sp_ss.qa_date_lt1753
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DATE1   datetime2(7),
  COL_DATE2   datetime2(7),
  COL_DATE3   datetime2(7),
  COL_DATE4   datetime2(7),
  COL_DATE5   datetime2(7),
PRIMARY KEY(COL_NUMBER)
)
go


----------------------------

IF OBJECT_ID('sp_ss.qa_timestamp', 'U') IS NOT NULL
drop table sp_ss.qa_timestamp
go
create table sp_ss.qa_timestamp
(
  COL_NUMBER       numeric(25,2) not null,
  COL_TIMESTAMP1   datetimeoffset(4),
  COL_TIMESTAMP2   datetime2(6),
  COL_TIMESTAMP3   datetimeoffset(3),
  COL_TIMESTAMP4   datetime2(2),
  COL_TIMESTAMP5   datetimeoffset(5),
  COL_TIMESTAMP6   datetime2(7),
  COL_TIMESTAMP7   datetimeoffset(6),
  COL_TIMESTAMP8   datetime2(7),
  COL_TIMESTAMP9   datetimeoffset(7),
  COL_TIMESTAMP10  datetimeoffset(7),
PRIMARY KEY(COL_NUMBER)
)
go


----------------------------

/*
IF OBJECT_ID('sp_ss.qa_number', 'U') IS NOT NULL
drop table sp_ss.qa_number
go
create table sp_ss.qa_number
(
  COL_NUMBER    numeric(25,2) not null,
  COL_NUMBER1   numeric(12,2),
  COL_NUMBER2   numeric(18,3),
  COL_NUMBER3   numeric(25,4),
  COL_NUMBER4   numeric(30,5),
  COL_NUMBER5   numeric(38),
PRIMARY KEY(COL_NUMBER)
)
go
*/

IF OBJECT_ID('sp_ss.qa_number', 'U') IS NOT NULL
drop table sp_ss.qa_number
go
create table sp_ss.qa_number
(
  COL_NUMBER    numeric(25,2) not null,
  COL_NUMBER1   numeric(20,7),
  COL_NUMBER2   numeric(24,4),
  COL_NUMBER3   numeric(26,2),
  COL_NUMBER4   numeric(27,1),
  COL_NUMBER5   numeric(28),
PRIMARY KEY(COL_NUMBER)
)
go

----------------------------

/*
IF OBJECT_ID('sp_ss.qa_float', 'U') IS NOT NULL
drop table sp_ss.qa_float
go
create table sp_ss.qa_float
(
  COL_NUMBER  numeric(25,2) not null,
  COL_FLOAT1   float(10),
  COL_FLOAT2   float(20),
  COL_FLOAT3   float(40),
  COL_FLOAT4   float(50),
  COL_FLOAT5   float(53),
PRIMARY KEY(COL_NUMBER)
)
go
*/

IF OBJECT_ID('sp_ss.qa_float', 'U') IS NOT NULL
drop table sp_ss.qa_float
go
create table sp_ss.qa_float
(
  COL_NUMBER  numeric(25,2) not null,
  COL_FLOAT1   float(10),
  COL_FLOAT2   float(15),
  COL_FLOAT3   float(20),
  COL_FLOAT4   float(25),
  COL_FLOAT5   float(28),
PRIMARY KEY(COL_NUMBER)
)
go

----------------------------

IF OBJECT_ID('sp_ss.qa_integer', 'U') IS NOT NULL
drop table sp_ss.qa_integer
go
create table sp_ss.qa_integer
(
  COL_NUMBER     numeric(25,2) not null,
  COL_INTEGER1   integer,
  COL_INTEGER2   int,
  COL_INTEGER3   integer,
  COL_INTEGER4   int,
  COL_INTEGER5   integer,
PRIMARY KEY(COL_NUMBER)
)
go

----------------------------

IF OBJECT_ID('sp_ss.qa_long', 'U') IS NOT NULL
drop table sp_ss.qa_long
go
create table sp_ss.qa_long
(
  COL_NUMBER   numeric(25,2) not null,
  COL_LONG     text,
PRIMARY KEY(COL_NUMBER)
)
go

----------------------------

IF OBJECT_ID('sp_ss.qa_raw', 'U') IS NOT NULL
drop table sp_ss.qa_raw
go
create table sp_ss.qa_raw
(
  COL_NUMBER   numeric(25,2) not null,
  COL_RAW1     varbinary(100),
  COL_RAW2     varbinary(200),
  COL_RAW3     varbinary(500),
  COL_RAW4     varbinary(1500),
  COL_RAW5     varbinary(2000),
PRIMARY KEY(COL_NUMBER)
)
go

----------------------------

IF OBJECT_ID('sp_ss.qa_long_raw', 'U') IS NOT NULL
drop table sp_ss.qa_long_raw
go
create table sp_ss.qa_long_raw
(
  COL_NUMBER      numeric(25,2) not null,
  COL_LONG_RAW    image,
PRIMARY KEY(COL_NUMBER)
)
go

-----------------------

IF OBJECT_ID('sp_ss.qa_anydata_char', 'U') IS NOT NULL
drop table sp_ss.qa_anydata_char
go
create table sp_ss.qa_anydata_char
(
  COL_NUMBER          numeric(25,2) not null,
  COL_ANYDATA_CHAR1   sql_variant,
  COL_ANYDATA_CHAR2   sql_variant,
  COL_ANYDATA_CHAR3   sql_variant,
  COL_ANYDATA_CHAR4   sql_variant,
  COL_ANYDATA_CHAR5   sql_variant
PRIMARY KEY(COL_NUMBER)
)
go

IF OBJECT_ID('sp_ss.qa_anydata_number', 'U') IS NOT NULL
drop table sp_ss.qa_anydata_number
go
create table sp_ss.qa_anydata_number
(
  COL_NUMBER          numeric(25,2) not null,
  COL_ANYDATA_NUMBER1   sql_variant,
  COL_ANYDATA_NUMBER2   sql_variant,
  COL_ANYDATA_NUMBER3   sql_variant,
  COL_ANYDATA_NUMBER4   sql_variant,
  COL_ANYDATA_NUMBER5   sql_variant
PRIMARY KEY(COL_NUMBER)
)
go

IF OBJECT_ID('sp_ss.qa_anydata_date', 'U') IS NOT NULL
drop table sp_ss.qa_anydata_date
go
create table sp_ss.qa_anydata_date
(
  COL_NUMBER          numeric(25,2) not null,
  COL_ANYDATA_DATE1   sql_variant,
  COL_ANYDATA_DATE2   sql_variant,
  COL_ANYDATA_DATE3   sql_variant,
  COL_ANYDATA_DATE4   sql_variant,
  COL_ANYDATA_DATE5   sql_variant
PRIMARY KEY(COL_NUMBER)
)
go

IF OBJECT_ID('sp_ss.qa_anydata_raw', 'U') IS NOT NULL
drop table sp_ss.qa_anydata_raw
go
create table sp_ss.qa_anydata_raw
(
  COL_NUMBER         numeric(25,2) not null,
  COL_ANYDATA_RAW1   sql_variant,
  COL_ANYDATA_RAW2   sql_variant,
  COL_ANYDATA_RAW3   sql_variant,
  COL_ANYDATA_RAW4   sql_variant,
  COL_ANYDATA_RAW5   sql_variant
PRIMARY KEY(COL_NUMBER)
)
go

IF OBJECT_ID('sp_ss.qa_anydata_varchar2', 'U') IS NOT NULL
drop table sp_ss.qa_anydata_varchar2
go
create table sp_ss.qa_anydata_varchar2
(
  COL_NUMBER               numeric(25,2) not null,
  COL_ANYDATA_VARCHAR2_1   sql_variant,
  COL_ANYDATA_VARCHAR2_2   sql_variant,
  COL_ANYDATA_VARCHAR2_3   sql_variant,
  COL_ANYDATA_VARCHAR2_4   sql_variant,
  COL_ANYDATA_VARCHAR2_5   sql_variant
PRIMARY KEY(COL_NUMBER)
)
go

IF OBJECT_ID('sp_ss.qa_anydata_timestamp', 'U') IS NOT NULL
drop table sp_ss.qa_anydata_timestamp
go
create table sp_ss.qa_anydata_timestamp
(
  COL_NUMBER               numeric(25,2) not null,
  COL_ANYDATA_TIMESTAMP1   sql_variant,
  COL_ANYDATA_TIMESTAMP2   sql_variant,
  COL_ANYDATA_TIMESTAMP3   sql_variant,
  COL_ANYDATA_TIMESTAMP4   sql_variant,
  COL_ANYDATA_TIMESTAMP5   sql_variant,
  COL_ANYDATA_TIMESTAMP6   sql_variant,
  COL_ANYDATA_TIMESTAMP7   sql_variant,
  COL_ANYDATA_TIMESTAMP8   sql_variant,
  COL_ANYDATA_TIMESTAMP9   sql_variant,
  COL_ANYDATA_TIMESTAMP10  sql_variant
PRIMARY KEY(COL_NUMBER)
)
go
-----------------------

IF OBJECT_ID('sp_ss.qa_clob_lt4k', 'U') IS NOT NULL
drop table sp_ss.qa_clob_lt4k
go
create table sp_ss.qa_clob_lt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   text,
  COL_CLOB2   text,
  COL_CLOB3   text,
  COL_CLOB4   text,
  COL_CLOB5   text,
PRIMARY KEY(COL_NUMBER)
)
go


-----------------------

IF OBJECT_ID('sp_ss.qa_clob_lt32k', 'U') IS NOT NULL
drop table sp_ss.qa_clob_lt32k
go
create table sp_ss.qa_clob_lt32k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   text,
  COL_CLOB2   text,
  COL_CLOB3   text,
  COL_CLOB4   text,
  COL_CLOB5   text,
PRIMARY KEY(COL_NUMBER)
)
go

-----------------------

IF OBJECT_ID('sp_ss.qa_clob_ltgt4k', 'U') IS NOT NULL
drop table sp_ss.qa_clob_ltgt4k
go
create table sp_ss.qa_clob_ltgt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   text,
  COL_CLOB2   text,
  COL_CLOB3   text,
  COL_CLOB4   text,
  COL_CLOB5   text,
PRIMARY KEY(COL_NUMBER)
)
go

-----------------------

IF OBJECT_ID('sp_ss.qa_clob_gt4k', 'U') IS NOT NULL
drop table sp_ss.qa_clob_gt4k
go
create table sp_ss.qa_clob_gt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   text,
  COL_CLOB2   text,
  COL_CLOB3   text,
  COL_CLOB4   text,
  COL_CLOB5   text,
PRIMARY KEY(COL_NUMBER)
)
go

-----------------------

/*
IF OBJECT_ID('sp_ss.qa_nclob_lt4k', 'U') IS NOT NULL
drop table sp_ss.qa_nclob_lt4k
go
create table sp_ss.qa_nclob_lt4k
(
  COL_NUMBER   numeric(25,2) not null,
  COL_NCLOB1   text,
  COL_NCLOB2   text,
  COL_NCLOB3   text,
  COL_NCLOB4   text,
  COL_NCLOB5   text,
PRIMARY KEY(COL_NUMBER)
)
go


-----------------------

IF OBJECT_ID('sp_ss.qa_nclob_lt32k', 'U') IS NOT NULL
drop table sp_ss.qa_nclob_lt32k
go
create table sp_ss.qa_nclob_lt32k
(
  COL_NUMBER   numeric(25,2) not null,
  COL_NCLOB1   text,
  COL_NCLOB2   text,
  COL_NCLOB3   text,
  COL_NCLOB4   text,
  COL_NCLOB5   text,
PRIMARY KEY(COL_NUMBER)
)
go

-----------------------

IF OBJECT_ID('sp_ss.qa_nclob_ltgt4k', 'U') IS NOT NULL
drop table sp_ss.qa_nclob_ltgt4k
go
create table sp_ss.qa_nclob_ltgt4k
(
  COL_NUMBER   numeric(25,2) not null,
  COL_NCLOB1   text,
  COL_NCLOB2   text,
  COL_NCLOB3   text,
  COL_NCLOB4   text,
  COL_NCLOB5   text,
PRIMARY KEY(COL_NUMBER)
)
go
*/

-----------------------

IF OBJECT_ID('sp_ss.qa_blob_lt4k', 'U') IS NOT NULL
drop table sp_ss.qa_blob_lt4k
go
create table sp_ss.qa_blob_lt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_BLOB1   image,
  COL_BLOB2   image,
  COL_BLOB3   image,
  COL_BLOB4   image,
  COL_BLOB5   image,
PRIMARY KEY(COL_NUMBER)
)
go

-----------------------

IF OBJECT_ID('sp_ss.qa_blob_lt32k', 'U') IS NOT NULL
drop table sp_ss.qa_blob_lt32k
go
create table sp_ss.qa_blob_lt32k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_BLOB1   image,
  COL_BLOB2   image,
  COL_BLOB3   image,
  COL_BLOB4   image,
  COL_BLOB5   image,
PRIMARY KEY(COL_NUMBER)
)
go

-----------------------

IF OBJECT_ID('sp_ss.qa_blob_gt4k', 'U') IS NOT NULL
drop table sp_ss.qa_blob_gt4k
go
create table sp_ss.qa_blob_gt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_BLOB1   image,
  COL_BLOB2   image,
  COL_BLOB3   image,
  COL_BLOB4   image,
  COL_BLOB5   image,
PRIMARY KEY(COL_NUMBER)
)
go

-----------------------

IF OBJECT_ID('sp_ss.qa_blob_ltgt4k', 'U') IS NOT NULL
drop table sp_ss.qa_blob_ltgt4k
go
create table sp_ss.qa_blob_ltgt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_BLOB1   image,
  COL_BLOB2   image,
  COL_BLOB3   image,
  COL_BLOB4   image,
  COL_BLOB5   image,
PRIMARY KEY(COL_NUMBER)
)
go

-----------------------

IF OBJECT_ID('sp_ss.qa_all', 'U') IS NOT NULL
drop table sp_ss.qa_all
go
create table sp_ss.qa_all
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CHAR   CHAR(2000),
  COL_VARCHAR2 VARCHAR(4000),
  COL_DATE_LT1753   datetime2(7),
  COL_DATE_GT1753   datetime,
  COL_TIMESTAMP datetime2(7),
  COL_TIMESTAMP_TZ datetimeoffset(7),
  COL_FLOAT  FLOAT(30),
  COL_LONG   text,
  COL_RAW    varbinary(1000),
  --COL_LONG_RAW LONG RAW,
  COL_ANYDATA_CHAR sql_variant,
  COL_ANYDATA_VARCHAR2 sql_variant,
  COL_ANYDATA_NUMBER sql_variant,
  COL_ANYDATA_DATE sql_variant,
  COL_ANYDATA_TIMESTAMP sql_variant,
  COL_ANYDATA_RAW sql_variant,
  COL_CLOB_NULL   text,
  COL_CLOB_LT4K   text,
  COL_CLOB_GT4K   text,
  COL_CLOB_LTGT4K   text,
  COL_BLOB_NULL   image,
  COL_BLOB_LT4K   image,
  COL_BLOB_GT4K   image,
  COL_BLOB_LTGT4K   image
)
go

--------------------------------

IF OBJECT_ID('sp_ss.qa_blob_null', 'U') IS NOT NULL
drop table sp_ss.qa_blob_null
go
create table sp_ss.qa_blob_null
(
  COL_NUMBER  numeric(25,2) not null,
  COL_BLOB1   image,
  COL_BLOB2   image,
  COL_BLOB3   image,
  COL_BLOB4   image,
  COL_BLOB5   image,
PRIMARY KEY(COL_NUMBER)
)
go

IF OBJECT_ID('sp_ss.qa_clob_null', 'U') IS NOT NULL
drop table sp_ss.qa_clob_null
go
create table sp_ss.qa_clob_null
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   text,
  COL_CLOB2   text,
  COL_CLOB3   text,
  COL_CLOB4   text,
  COL_CLOB5   text,
PRIMARY KEY(COL_NUMBER)
)
go

-------------------------------
IF OBJECT_ID('sp_ss.qa_all_uk', 'U') IS NOT NULL
drop table sp_ss.qa_all_uk
go
create table sp_ss.qa_all_uk
(
  COL_NUMBER  numeric(25,2) not null,
  COL_NUMBER_UK1 numeric(30),
  COL_CHAR_UK2 char(200) not null,
  COL_TIMESTAMP_UK3 datetime2(7),
  COL_VARCHAR2_UK4 varchar(400) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
  COL_CHAR   char(2000),
  COL_VARCHAR2 varchar(4000),
  COL_DATE_LT1753   datetime2(7),
  COL_DATE_GT1753   datetime,
  COL_TIMESTAMP datetime2(7),
  COL_TIMESTAMP_TZ datetimeoffset(7),
  COL_FLOAT  FLOAT(30),
  COL_LONG   text,
  COL_RAW    varbinary(1000),
  --COL_LONG_RAW LONG RAW,
  COL_ANYDATA_CHAR sql_variant,
  COL_ANYDATA_VARCHAR2 sql_variant,
  COL_ANYDATA_NUMBER sql_variant,
  COL_ANYDATA_DATE sql_variant,
  COL_ANYDATA_TIMESTAMP sql_variant,
  COL_ANYDATA_RAW sql_variant,
  COL_CLOB_NULL   text,
  COL_CLOB_LT4K   text,
  COL_CLOB_GT4K   text,
  COL_CLOB_LTGT4K   text,
  COL_BLOB_NULL   image,
  COL_BLOB_LT4K   image,
  COL_BLOB_GT4K   image,
  COL_BLOB_LTGT4K   image,
CONSTRAINT "UK_QA_ALL_UK1" UNIQUE("COL_NUMBER_UK1"),
--CONSTRAINT "UK_QA_ALL_UK2" UNIQUE("COL_NUMBER","COL_CHAR_UK2"),
CONSTRAINT "UK_QA_ALL_UK3" UNIQUE("COL_TIMESTAMP_UK3","COL_VARCHAR2_UK4")
)
go
