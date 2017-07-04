use sp_ms
DROP table IF EXISTS sp_ms.qa_float;


CREATE TABLE sp_ms.qa_float (

 COL_NUMBER  numeric(25,2) NOT NULL,
  COL_FLOAT1  double ,
  COL_FLOAT2   double,
  COL_FLOAT3   double,
  COL_FLOAT4   double,
  COL_FLOAT5   double,
  PRIMARY KEY(COL_NUMBER)

);
exit
