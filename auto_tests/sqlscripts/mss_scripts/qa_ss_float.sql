use sp_ss
IF OBJECT_ID('sp_ss.qa_float', 'U') IS NOT NULL
drop table sp_ss.qa_float
go
create table sp_ss.qa_float
(
  COL_NUMBER  numeric(25,2) not null,
  COL_FLOAT1   float(10),
  COL_FLOAT2   float(15),
  COL_FLOAT3   float(20),
  COL_FLOAT4   float(25),
  COL_FLOAT5   float(28),
PRIMARY KEY(COL_NUMBER)
)
go

