use sp_ms
DROP table IF EXISTS sp_ms.qa_binary_double;


CREATE TABLE sp_ms.qa_binary_double(

 COL_NUMBER  numeric(25,2) NOT NULL,
  COL_DOUBLE1   double ,
  COL_DOUBLE2   double,
  COL_DOUBLE3   double,
  COL_DOUBLE4   double,
  COL_DOUBLE5   double,
  PRIMARY KEY(COL_NUMBER)

);
exit
