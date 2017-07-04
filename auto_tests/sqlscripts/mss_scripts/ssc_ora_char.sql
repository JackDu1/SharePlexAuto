use sp_ss
IF OBJECT_ID('sp_ss.ssc_char', 'U') IS NOT NULL
drop table sp_ss.ssc_char
go
create table sp_ss.ssc_char (
COL_NUMBER numeric(25,2) primary key, 
COL_CHAR1 char(100), 
COL_CHAR2 char(500),
COL_CHAR3 char(1000),
COL_CHAR4 char(1500),
COL_CHAR5 char(2000));
go
