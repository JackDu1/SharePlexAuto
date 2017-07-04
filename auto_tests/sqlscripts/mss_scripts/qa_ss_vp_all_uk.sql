use sp_ss
IF OBJECT_ID('sp_ss.qa_all_uk', 'U') IS NOT NULL
drop table sp_ss.qa_all_uk
go
create table sp_ss.qa_all_uk
(
  COL_NUMBER  numeric(25,2) not null,
  COL_NUMBER_UK1 numeric(30),
  COL_CHAR_UK2 CHAR(50),
  COL_TIMESTAMP_UK3 datetime2(7),
  COL_VARCHAR2_UK4 VARCHAR2(40),
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
  COL_BLOB_LTGT4K   image,
CONSTRAINT "UK_QA_ALL_UK1" UNIQUE("COL_NUMBER_UK1"),
CONSTRAINT "UK_QA_ALL_UK2" UNIQUE("COL_CHAR_UK2"),
CONSTRAINT "UK_QA_ALL_UK3" UNIQUE("COL_TIMESTAMP_UK3","COL_VARCHAR2_UK4")
)
go

