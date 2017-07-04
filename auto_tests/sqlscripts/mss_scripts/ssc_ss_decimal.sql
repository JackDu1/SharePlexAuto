use sp_ss
IF OBJECT_ID('sp_ss.ssc_decimal', 'U') IS NOT NULL
drop table sp_ss.ssc_decimal
go
CREATE TABLE sp_ss.ssc_decimal (COL1 decimal(35,2) PRIMARY KEY
,COL2 decimal(30,7)
,COL3 DECIMAL(34,4)
,COL4 DECIMAL(36,3)
,COL5 DECIMAL(37,1)
,COL6 DECIMAL(38,38)
,COL7 DECIMAL(12,9))
go
