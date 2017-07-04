use sp_ms
DROP table IF EXISTS sp_ms.qa_all_uk;


create table sp_ms.qa_all_uk
(
  COL_NUMBER  numeric(25,2) not null,
  COL_NUMBER_UK1 numeric(30) not null,
  COL_CHAR_UK2 CHAR(200) CHARACTER SET utf8 COLLATE utf8_bin not null,
  COL_TIMESTAMP_UK3 datetime(6) not null,
  COL_VARCHAR2_UK4 VARCHAR(400),
  COL_CHAR   CHAR(255),
  COL_VARCHAR2 VARCHAR(4000),
  COL_DATE_LT1753   datetime,
  COL_DATE_GT1753   datetime,
  COL_TIMESTAMP datetime(6),
  COL_TIMESTAMP_TZ datetime(6),
  COL_FLOAT  float(30),
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

exit
