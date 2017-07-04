DROP TABLE IF EXISTS sp_ms.qa_binary_float;

CREATE TABLE sp_ms.qa_binary_float
(
  COL_NUMBER  numeric(25,2) not null,
  COL_FLOAT1   double,
  COL_FLOAT2   double,
  COL_FLOAT3   double,
  COL_FLOAT4   double,
  COL_FLOAT5   double,
PRIMARY KEY(COL_NUMBER)
);

DROP TABLE IF EXISTS sp_ms.qa_binary_double;

CREATE TABLE sp_ms.qa_binary_double
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DOUBLE1   double,
  COL_DOUBLE2   double,
  COL_DOUBLE3   double,
  COL_DOUBLE4   double,
  COL_DOUBLE5   double,
PRIMARY KEY(COL_NUMBER)
);

