use sp_ms
DROP table IF EXISTS sp_ms.qa_all_nopk;

create table sp_ms.qa_all_nopk
(
  COL_NUMBER  numeric(25,2) not null, 
  COL_CHAR   CHAR(255),
  COL_VARCHAR2 VARCHAR(4000),
  COL_DATE_LT1753   datetime,
  COL_DATE_GT1753   datetime,
  COL_TIMESTAMP datetime(6),
  COL_TIMESTAMP_TZ datetime(6),
  COL_FLOAT  float,
  COL_LONG   text,
  COL_RAW    varbinary(4000),
  COL_CLOB_NULL   longtext,
  COL_CLOB_LT4K   longtext,
  COL_CLOB_GT4K   longtext,
  COL_CLOB_LTGT4K  longtext,
  COL_BLOB_NULL   longblob,
  COL_BLOB_LT4K   longblob,
  COL_BLOB_GT4K   longblob,
  COL_BLOB_LTGT4K   longblob
);


DROP table IF EXISTS sp_ms.qa_all_uk;

create table sp_ms.qa_all_uk
(
  COL_NUMBER  numeric(25,2) not null,
  COL_NUMBER_UK1 numeric(30) not null,
  COL_CHAR_UK2 CHAR(200) not null,
  COL_TIMESTAMP_UK3 datetime(6) not null,
  COL_VARCHAR2_UK4 VARCHAR(400),
  COL_CHAR   CHAR(255),
  COL_VARCHAR2 VARCHAR(4000),
  COL_DATE_LT1753   datetime,
  COL_DATE_GT1753   datetime,
  COL_TIMESTAMP datetime(6),
  COL_TIMESTAMP_TZ datetime(6),
  COL_FLOAT  float,
  COL_LONG   text,
  COL_RAW    varbinary(4000),
  COL_CLOB_NULL   longtext,
  COL_CLOB_LT4K   longtext,
  COL_CLOB_GT4K   longtext,
  COL_CLOB_LTGT4K   longtext,
  COL_BLOB_NULL   longblob,
  COL_BLOB_LT4K   longblob,
  COL_BLOB_GT4K   longblob,
  COL_BLOB_LTGT4K   longblob,
CONSTRAINT UK_QA_ALL_UK1 UNIQUE(COL_NUMBER_UK1),
CONSTRAINT UK_QA_ALL_UK2 UNIQUE(COL_CHAR_UK2),
CONSTRAINT UK_QA_ALL_UK3 UNIQUE(COL_TIMESTAMP_UK3,COL_VARCHAR2_UK4)
);



/**
drop table  IF EXISTS sp_ms.qa_binary_double;

CREATE TABLE sp_ms.qa_binary_double
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DOUBLE1   double,
  COL_DOUBLE2   double,
  COL_DOUBLE3   double,
  COL_DOUBLE4   double,
  COL_DOUBLE5   double,
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_binary_float;

CREATE TABLE sp_ms.qa_binary_float
(
  COL_NUMBER  numeric(25,2) not null,
  COL_FLOAT1   double,
  COL_FLOAT2   double,
  COL_FLOAT3   double,
  COL_FLOAT4   double,
  COL_FLOAT5   double,
PRIMARY KEY(COL_NUMBER)
);
*/

DROP TABLE IF EXISTS sp_ms.qa_blob_gt4k;

create table sp_ms.qa_blob_gt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_BLOB1   longblob,
  COL_BLOB2   longblob,
  COL_BLOB3   longblob,
  COL_BLOB4   longblob,
  COL_BLOB5   longblob,
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_blob_lt32k;

create table sp_ms.qa_blob_lt32k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_BLOB1   longblob,
  COL_BLOB2   longblob,
  COL_BLOB3   longblob,
  COL_BLOB4   longblob,
  COL_BLOB5   longblob,
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_blob_lt4k;

create table sp_ms.qa_blob_lt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_BLOB1   longblob,
  COL_BLOB2   longblob,
  COL_BLOB3   longblob,
  COL_BLOB4   longblob,
  COL_BLOB5   longblob,
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_blob_ltgt4k;

create table sp_ms.qa_blob_ltgt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_BLOB1   longblob,
  COL_BLOB2   longblob,
  COL_BLOB3   longblob,
  COL_BLOB4   longblob,
  COL_BLOB5   longblob,
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_blob_null;

create table sp_ms.qa_blob_null
(
  COL_NUMBER  numeric(25,2) not null,
  COL_BLOB1   longblob,
  COL_BLOB2   longblob,
  COL_BLOB3   longblob,
  COL_BLOB4   longblob,
  COL_BLOB5   longblob,
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_char;

CREATE TABLE sp_ms.qa_char
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CHAR1   char(20),
  COL_CHAR2   char(50),
  COL_CHAR3   char(100),
  COL_CHAR4   char(150),
  COL_CHAR5   char(255),
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_clob_gt4k;

create table sp_ms.qa_clob_gt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   longtext,
  COL_CLOB2   longtext,
  COL_CLOB3   longtext,
  COL_CLOB4   longtext,
  COL_CLOB5   longtext,
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_clob_lt32k;

create table sp_ms.qa_clob_lt32k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   longtext,
  COL_CLOB2   longtext,
  COL_CLOB3   longtext,
  COL_CLOB4   longtext,
  COL_CLOB5   longtext,
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_clob_lt4k;

create table sp_ms.qa_clob_lt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   longtext,
  COL_CLOB2   longtext,
  COL_CLOB3   longtext,
  COL_CLOB4   longtext,
  COL_CLOB5   longtext,
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_clob_ltgt4k;

create table sp_ms.qa_clob_ltgt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   longtext,
  COL_CLOB2   longtext,
  COL_CLOB3   longtext,
  COL_CLOB4   longtext,
  COL_CLOB5   longtext,
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_clob_null;

CREATE TABLE sp_ms.qa_clob_null
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   longtext,
  COL_CLOB2   longtext,
  COL_CLOB3   longtext,
  COL_CLOB4   longtext,
  COL_CLOB5   longtext,
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_date_lt1753;

CREATE TABLE sp_ms.qa_date_lt1753
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DATE1   datetime,
  COL_DATE2   datetime,
  COL_DATE3   datetime,
  COL_DATE4   datetime,
  COL_DATE5   datetime,
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_date_gt1753;

CREATE TABLE sp_ms.qa_date_gt1753
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DATE1   datetime,
  COL_DATE2   datetime,
  COL_DATE3   datetime,
  COL_DATE4   datetime,
  COL_DATE5   datetime,
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_long_raw;

create table sp_ms.qa_long_raw
(
  COL_NUMBER      numeric(25,2) not null,
  COL_LONG_RAW    blob,
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_long;

CREATE TABLE sp_ms.qa_long
(
  COL_NUMBER   numeric(25,2) not null,
  COL_LONG     text,
PRIMARY KEY(COL_NUMBER)
);

DROP TABLE IF EXISTS sp_ms.qa_number;

CREATE TABLE sp_ms.qa_number
(
  COL_NUMBER    numeric(25,2) not null,
  COL_NUMBER1   numeric(20,7),
  COL_NUMBER2   numeric(24,4),
  COL_NUMBER3   numeric(26,2),
  COL_NUMBER4   numeric(27,1),
  COL_NUMBER5   numeric(28),
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_raw;


CREATE TABLE sp_ms.qa_raw
(
  COL_NUMBER   numeric(25,2) not null,
  COL_RAW1     varbinary(200),
  COL_RAW2     varbinary(400),
  COL_RAW3     varbinary(1000),
  COL_RAW4     varbinary(3000),
  COL_RAW5     varbinary(4000),
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_timestamp;

CREATE TABLE sp_ms.qa_timestamp
(
  COL_NUMBER       numeric(25,2),
  COL_TIMESTAMP1   datetime(4),
  COL_TIMESTAMP2   datetime(6),
  COL_TIMESTAMP3   datetime(3),
  COL_TIMESTAMP4   datetime(2),
  COL_TIMESTAMP5   datetime(5),
  COL_TIMESTAMP6   datetime(6),
  COL_TIMESTAMP7   datetime(6),
  COL_TIMESTAMP8   datetime(6),
  COL_TIMESTAMP9   datetime(6),
  COL_TIMESTAMP10  datetime(6)
,
PRIMARY KEY(COL_NUMBER)
);


DROP TABLE IF EXISTS sp_ms.qa_varchar2;

CREATE TABLE sp_ms.qa_varchar2
(
  COL_NUMBER       numeric(25,2) not null,
  COL_VARCHAR2_1   varchar(100),
  COL_VARCHAR2_2   varchar(500),
  COL_VARCHAR2_3   varchar(1000),
  COL_VARCHAR2_4   varchar(2000),
  COL_VARCHAR2_5   varchar(4000),
PRIMARY KEY(COL_NUMBER)
);


exit
