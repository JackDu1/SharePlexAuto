use sp_ss
IF OBJECT_ID('sp_ss.qa_all_nopk', 'U') IS NOT NULL
drop table sp_ss.qa_all_nopk
go
create table sp_ss.qa_all_nopk
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CHAR   CHAR(2000),
  COL_VARCHAR2 VARCHAR(4000),
  COL_DATE_LT1753   datetime2(7),
  COL_DATE_GT1753   datetime,
  COL_TIMESTAMP datetime2(7),
  COL_TIMESTAMP_TZ datetimeoffset(7),
  COL_FLOAT  FLOAT(28),
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

