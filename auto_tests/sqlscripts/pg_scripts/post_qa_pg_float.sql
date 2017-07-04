--for postgresql
--dzhu, 7/28/2016
DROP TABLE IF EXISTS sp_pg.qa_float;

CREATE TABLE sp_pg.qa_float
(
  COL_NUMBER  numeric(25,2) not null,
  COL_FLOAT1   double precision,
  COL_FLOAT2   double precision,
  COL_FLOAT3   double precision,
  COL_FLOAT4   double precision,
  COL_FLOAT5   double precision,
PRIMARY KEY(COL_NUMBER)
);

