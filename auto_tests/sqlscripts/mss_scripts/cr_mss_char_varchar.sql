use sp_ss

IF OBJECT_ID('sp_ssc.mss_char', 'U') IS NOT NULL
drop table sp_ssc.mss_char
go
create table sp_ssc.mss_char
(
  COL_NUMBER    numeric not null,
  COL_CHAR1   CHAR(10),
  COL_CHAR2   CHAR(30),
  COL_CHAR3   CHAR(200),
  COL_CHAR4   CHAR(2600),
  COL_CHAR5   CHAR(5000),
PRIMARY KEY(COL_NUMBER, COL_CHAR1)
)
go



IF OBJECT_ID('sp_ssc.mss_varchar', 'U') IS NOT NULL
drop table sp_ssc.mss_varchar
go
create table sp_ssc.mss_varchar
(
  COL_NUMBER    numeric not null,
  COL_VARCHAR1   VARCHAR(200),
  COL_VARCHAR2   VARCHAR(3000),
  COL_VARCHAR3   VARCHAR(5000),
  COL_VARCHAR4   VARCHAR(8000),
  COL_VARCHAR5   VARCHAR(8000),
PRIMARY KEY(COL_NUMBER)
)
go



