use sp_ss
IF OBJECT_ID('sp_ss.ssc_nvarchar', 'U') IS NOT NULL
drop table sp_ss.ssc_nvarchar
go
CREATE TABLE sp_ss.ssc_nvarchar(
COL_NUMBER numeric(25,2),
COL_NVARCHAR1 nvarchar(100),
COL_NVARCHAR2 nvarchar(1000),
COL_NVARCHAR3 nvarchar(2000),
COL_NVARCHAR4 nvarchar(2001),
COL_NVARCHAR5 nvarchar(4000),
COL_NVARCHAR6 nvarchar(max),
Primary key (COL_NUMBER))
go
