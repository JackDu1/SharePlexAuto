use sp_ss

IF OBJECT_ID('sp_ssc.mss_nchar', 'U') IS NOT NULL
drop table sp_ssc.mss_nchar
go
create table sp_ssc.mss_nchar
(
  COL_NUMBER    numeric not null,
  COL_NCHAR1   NCHAR(10),
  COL_NCHAR2   NCHAR(10),
  COL_NCHAR3   NCHAR(10),
  COL_NCHAR4   NCHAR(10),
  COL_NCHAR5   NCHAR(3800),
PRIMARY KEY(COL_NUMBER)
)
go



IF OBJECT_ID('sp_ssc.mss_nvarchar', 'U') IS NOT NULL
drop table sp_ssc.mss_nvarchar
go
create table sp_ssc.mss_nvarchar
(
  COL_NUMBER    numeric not null,
  COL_NVARCHAR1   NVARCHAR(200),
  COL_NVARCHAR2   NVARCHAR(1000),
  COL_NVARCHAR3   NVARCHAR(3000),
  COL_NVARCHAR4   NVARCHAR(4000),
  COL_NVARCHAR5   NVARCHAR(4000),
PRIMARY KEY(COL_NUMBER)
)
go

IF OBJECT_ID('sp_ssc.mss_ntext', 'U') IS NOT NULL
drop table sp_ssc.mss_ntext
go
create table sp_ssc.mss_ntext
(
  COL_NUMBER    numeric not null,
  COL_NTEXT1   NTEXT,
  COL_NTEXT2   NTEXT,
  COL_NTEXT3   NTEXT,
  COL_NTEXT4   NTEXT,
  COL_NTEXT5   NTEXT,
PRIMARY KEY(COL_NUMBER)
)
go



IF OBJECT_ID('sp_ssc.mss_nvarchar_max', 'U') IS NOT NULL
drop table sp_ssc.mss_nvarchar_max
go
create table sp_ssc.mss_nvarchar_max
(
  COL_NUMBER    numeric not null,
  COL_NVARCHAR_MAX1   NVARCHAR(max),
  COL_NVARCHAR_MAX2   NVARCHAR(max),
  COL_NVARCHAR_MAX3   NVARCHAR(max),
  COL_NVARCHAR_MAX4   NVARCHAR(max),
  COL_NVARCHAR_MAX5   NVARCHAR(max),
PRIMARY KEY(COL_NUMBER)
)
go

