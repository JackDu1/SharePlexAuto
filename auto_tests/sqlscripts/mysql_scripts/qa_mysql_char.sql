use sp_ms
DROP table IF EXISTS sp_ms.qa_char;

CREATE TABLE sp_ms.qa_char(

 COL_NUMBER  numeric(25,2) NOT NULL,
  COL_CHAR1 CHAR(20),
  COL_CHAR2  CHAR(50),
  COL_CHAR3  CHAR(100),
  COL_CHAR4  CHAR(150),
  COL_CHAR5  CHAR(255),
  PRIMARY KEY(COL_NUMBER)

);

exit

