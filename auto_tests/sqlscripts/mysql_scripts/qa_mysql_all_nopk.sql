use sp_ms
drop table  IF EXISTS sp_ms.qa_all_nopk;

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

exit
