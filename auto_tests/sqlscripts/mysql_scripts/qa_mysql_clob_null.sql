use sp_ms
DROP table IF EXISTS sp_ms.qa_clob_null;


CREATE TABLE sp_ms.qa_clob_null(

 COL_NUMBER  numeric(25,2) NOT NULL,
  COL_CLOB1 longtext,
  COL_CLOB2 longtext,
  COL_CLOB3 longtext,
  COL_CLOB4 longtext,
  COL_CLOB5 longtext,
  PRIMARY KEY(COL_NUMBER)

);
exit
