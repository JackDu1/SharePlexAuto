use sp_ss
IF OBJECT_ID('sp_ssc.mss_decimal', 'U') IS NOT NULL
drop table sp_ssc.mss_decimal
go
create table sp_ssc.mss_decimal
(
  COL_NUMBER    numeric not null,
  COL_DECIMAL1   DECIMAL(35,16),
  COL_DECIMAL2   DECIMAL(22,7),
  COL_DECIMAL3   DECIMAL(18,9),
  COL_DECIMAL4   DECIMAL(12,3),
  COL_DECIMAL5   DECIMAL,
PRIMARY KEY(COL_NUMBER)
)
go


IF OBJECT_ID('sp_ssc.mss_numeric', 'U') IS NOT NULL
drop table sp_ssc.mss_numeric
go
create table sp_ssc.mss_numeric
(
  COL_NUMBER    numeric not null,
  COL_NUMERIC1   NUMERIC(38,10),
  COL_NUMERIC2   NUMERIC(20,20),
  COL_NUMERIC3   NUMERIC(17,8),
  COL_NUMERIC4   NUMERIC(18,6),
  COL_NUMERIC5   NUMERIC,
PRIMARY KEY(COL_NUMBER)
)
go



IF OBJECT_ID('sp_ssc.mss_real', 'U') IS NOT NULL
drop table sp_ssc.mss_real
go
create table sp_ssc.mss_real
(
  COL_NUMBER    numeric not null,
  COL_REAL1   REAL,
  COL_REAL2   REAL,
  COL_REAL3   REAL,
  COL_REAL4   REAL,
  COL_REAL5   REAL,
PRIMARY KEY(COL_NUMBER)
)
go



IF OBJECT_ID('sp_ssc.mss_float', 'U') IS NOT NULL
drop table sp_ssc.mss_float
go
create table sp_ssc.mss_float
(
  COL_NUMBER    numeric not null,
  COL_FLOAT1   FLOAT(20),
  COL_FLOAT2   FLOAT(25),
  COL_FLOAT3   FLOAT(44),
  COL_FLOAT4   FLOAT(53),
  COL_FLOAT5   FLOAT,
PRIMARY KEY(COL_NUMBER)
)
go
