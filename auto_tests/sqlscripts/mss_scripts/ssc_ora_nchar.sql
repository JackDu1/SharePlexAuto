use sp_ss
IF OBJECT_ID('sp_ss.ssc_nchar', 'U') IS NOT NULL
drop table sp_ss.ssc_nchar
go
CREATE TABLE sp_ss.ssc_nchar(
COL_NUMBER numeric(25,2),
COL_NCHAR1 nchar(100),
COL_NCHAR2 nchar(500),
COL_NCHAR3 nchar(1000),
COL_NCHAR4 nchar(2000),
Primary key (COL_NUMBER))
go
IF OBJECT_ID('sp_ss.ssc_nchar_max', 'U') IS NOT NULL
drop table sp_ss.ssc_nchar_max
go
CREATE TABLE sp_ss.ssc_nchar_max(
COL_NUMBER numeric(25,2),
COL_NCHAR1 nchar(100),
COL_NCHAR2 nchar(3700),
Primary key (COL_NUMBER))
go
