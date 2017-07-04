use sp_ss
IF OBJECT_ID('sp_ss.ssc_float', 'U') IS NOT NULL
drop table sp_ss.ssc_float
go
CREATE TABLE sp_ss.ssc_float (COL1 NUMERIC(25,2) PRIMARY KEY
,COL2 float(10),
COL3 FLOAT(15),
COL4 FLOAT(20),
COL5 FLOAT(25),
COL6 FLOAT(35),
COL7 FLOAT(49))
go
