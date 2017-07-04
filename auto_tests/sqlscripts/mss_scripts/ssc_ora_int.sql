use sp_ss
IF OBJECT_ID('sp_ss.ssc_int', 'U') IS NOT NULL
drop table sp_ss.ssc_int
go
CREATE TABLE sp_ss.ssc_int (COL1 INT primary key,
COL2 BIT,
COL3 TINYINT,
COL4 SMALLINT,
COL5 BIGINT)
go
