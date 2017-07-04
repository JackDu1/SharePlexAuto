use sp_ms
DROP table IF EXISTS sp_ms.qa_long;


CREATE TABLE sp_ms.qa_long(
 COL_NUMBER  numeric(25,2) NOT NULL,
COL_LONG    text,
  PRIMARY KEY(COL_NUMBER)
);
exit
