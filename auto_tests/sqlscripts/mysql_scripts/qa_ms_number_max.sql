use sp_ms
DROP table IF EXISTS sp_ms.qa_number_max;


CREATE TABLE sp_ms.qa_number_max(
 COL_NUMBER  numeric(25,2) NOT NULL,
COL_NUMBER1 numeric(65,0),
COL_NUMBER2 numeric(65,0),
COL_NUMBER3 numeric(65,0),
COL_NUMBER4 numeric(65,0),
  PRIMARY KEY(COL_NUMBER)
);
exit
