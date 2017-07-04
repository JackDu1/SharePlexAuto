--6-26-2016 Julia add 2nd table to test source binary_double due to SPO-2170 change data mappint (source binary_float and binary_double repalce float)
DROP TABLE IF EXISTS sp_pg.qa_binary_float;

CREATE TABLE sp_pg.qa_binary_float
(
  COL_NUMBER  numeric(25,2) not null,
  COL_FLOAT1   double precision,
  COL_FLOAT2   double precision,
  COL_FLOAT3   double precision,
  COL_FLOAT4   double precision,
  COL_FLOAT5   double precision,
PRIMARY KEY(COL_NUMBER)
);

DROP TABLE IF EXISTS sp_pg.qa_binary_double;

CREATE TABLE sp_pg.qa_binary_double
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DOUBLE1   double precision,
  COL_DOUBLE2   double precision,
  COL_DOUBLE3   double precision,
  COL_DOUBLE4   double precision,
  COL_DOUBLE5   double precision,
PRIMARY KEY(COL_NUMBER)
);

