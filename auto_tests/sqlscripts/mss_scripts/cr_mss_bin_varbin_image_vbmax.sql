use sp_ss

IF OBJECT_ID('sp_ssc.mss_binary', 'U') IS NOT NULL
drop table sp_ssc.mss_binary
go
create table sp_ssc.mss_binary
(
  COL_NUMBER    numeric not null,
  COL_BINARY1   BINARY(10),
  COL_BINARY2   BINARY(70),
  COL_BINARY3   BINARY(120),
  COL_BINARY4   BINARY(510),
  COL_BINARY5   BINARY(7200),
PRIMARY KEY(COL_NUMBER)
)
go



IF OBJECT_ID('sp_ssc.mss_varbinary', 'U') IS NOT NULL
drop table sp_ssc.mss_varbinary
go
create table sp_ssc.mss_varbinary
(
  COL_NUMBER    numeric not null,
  COL_VARBINARY1   VARBINARY(200),
  COL_VARBINARY2   VARBINARY(1000),
  COL_VARBINARY3   VARBINARY(3000),
  COL_VARBINARY4   VARBINARY(8000),
  COL_VARBINARY5   VARBINARY(8000),
PRIMARY KEY(COL_NUMBER)
)
go

IF OBJECT_ID('sp_ssc.mss_image', 'U') IS NOT NULL
drop table sp_ssc.mss_image
go
create table sp_ssc.mss_image
(
  COL_NUMBER    numeric not null,
  COL_IMAGE1   IMAGE,
  COL_IMAGE2   IMAGE,
  COL_IMAGE3   IMAGE,
  COL_IMAGE4   IMAGE,
  COL_IMAGE5   IMAGE,
PRIMARY KEY(COL_NUMBER)
)
go

IF OBJECT_ID('sp_ssc.mss_varbinary_max', 'U') IS NOT NULL
drop table sp_ssc.mss_varbinary_max
go
create table sp_ssc.mss_varbinary_max
(
  COL_NUMBER    numeric not null,
  COL_VARBINARY_MAX1   VARBINARY(max),
  COL_VARBINARY_MAX2   VARBINARY(max),
  COL_VARBINARY_MAX3   VARBINARY(max),
  COL_VARBINARY_MAX4   VARBINARY(max),
  COL_VARBINARY_MAX5   VARBINARY(max),
PRIMARY KEY(COL_NUMBER)
)
go