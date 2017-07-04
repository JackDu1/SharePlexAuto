use sp_ss
IF OBJECT_ID('sp_ss.ssc_numeric', 'U') IS NOT NULL
drop table sp_ss.ssc_numeric
go
CREATE TABLE sp_ss.ssc_numeric (COL1 numeric(35,2) PRIMARY KEY
,COL2 numeric(30,7)
,COL3 NUMERIC(37,1)
,COL4 NUMERIC(38,38)
,COL5 NUMERIC(12,9))
go

