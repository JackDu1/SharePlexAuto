use sp_ss
IF OBJECT_ID('sp_ss.ssc_binary', 'U') IS NOT NULL
drop table sp_ss.ssc_binary
IF OBJECT_ID('sp_ss.ssc_varbinary', 'U') IS NOT NULL
drop table sp_ss.ssc_varbinary
go
create table sp_ss.ssc_binary (
COL_NUMBER numeric(25,2) primary key,
COL_BINARY binary(100),
COL_BINARY1 binary(1000),
COL_BINARY2 binary(2000),
COL_BINARY3 binary(4000))
create table sp_ss.ssc_varbinary (
COL1 numeric(24,2) primary key, 
COL2 VARBINARY(100), 
COL3 VARBINARY(500), 
COL4 VARBINARY(1000), 
COL5 VARBINARY(2000), 
COL6 VARBINARY(3000), 
COL7 VARBINARY(max)) 
go
