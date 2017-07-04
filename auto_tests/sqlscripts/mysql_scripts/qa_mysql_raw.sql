use sp_ms
DROP table IF EXISTS sp_ms.qa_raw;


CREATE TABLE sp_ms.qa_raw(
 COL_NUMBER  numeric(25,2) NOT NULL,
COL_RAW1 varbinary(200),
COL_RAW2 varbinary(400),
COL_RAW3 varbinary(1000),
COL_RAW4 varbinary(3000),
COL_RAW5 varbinary(4000),
  PRIMARY KEY(COL_NUMBER)
);
exit
