--for postgresql
--dzhu, 7/28/2016
DROP TABLE IF EXISTS "sp_pg".qa_all_nopk;

create table sp_pg.qa_all_nopk
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CHAR   CHAR(2000),
  COL_VARCHAR2 VARCHAR(4000),
  COL_DATE_LT1753   timestamp(6),
  COL_DATE_GT1753   timestamp(6),
  COL_TIMESTAMP timestamp(6),
  COL_TIMESTAMP_TZ timestamp(6) with time zone,
  COL_FLOAT  FLOAT(30),
  COL_LONG   text,
--   COL_RAW    bytea(1000),
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
  COL_BLOB_LTGT4K   bytea
);

