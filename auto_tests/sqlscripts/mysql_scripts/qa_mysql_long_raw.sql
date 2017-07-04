use sp_ms
DROP table IF EXISTS sp_ms.qa_long_raw;


CREATE TABLE sp_ms.qa_long_raw(
 COL_NUMBER  numeric(25,2) NOT NULL,
COL_LONG_RAW    blob,
  PRIMARY KEY(COL_NUMBER)
);
exit
