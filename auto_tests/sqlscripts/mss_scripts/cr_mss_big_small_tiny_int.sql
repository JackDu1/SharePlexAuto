use sp_ss
IF OBJECT_ID('sp_ssc.mss_bigint', 'U') IS NOT NULL
drop table sp_ssc.mss_bigint
go
create table sp_ssc.mss_bigint
(
  COL_NUMBER    numeric not null,
  COL_BIGINT1   BIGINT,
  COL_BIGINT2   BIGINT,
  COL_BIGINT3   BIGINT,
  COL_BIGINT4   BIGINT,
  COL_BIGINT5   BIGINT,
PRIMARY KEY(COL_NUMBER)
)
go


IF OBJECT_ID('sp_ssc.mss_int', 'U') IS NOT NULL
drop table sp_ssc.mss_int
go
create table sp_ssc.mss_int
(
  COL_NUMBER    numeric not null,
  COL_INT1   INT,
  COL_INT2   INT,
  COL_INT3   INT,
  COL_INT4   INT,
  COL_INT5   INT,
PRIMARY KEY(COL_NUMBER, COL_INT1, COL_INT3, COL_INT5)
)
go



IF OBJECT_ID('sp_ssc.mss_smallint', 'U') IS NOT NULL
drop table sp_ssc.mss_smallint
go
create table sp_ssc.mss_smallint
(
  COL_NUMBER    numeric not null,
  COL_SMALLINT1   SMALLINT,
  COL_SMALLINT2   SMALLINT,
  COL_SMALLINT3   SMALLINT,
  COL_SMALLINT4   SMALLINT,
  COL_SMALLINT5   SMALLINT,
PRIMARY KEY(COL_NUMBER)
)
go



IF OBJECT_ID('sp_ssc.mss_tinyint', 'U') IS NOT NULL
drop table sp_ssc.mss_tinyint
go
create table sp_ssc.mss_tinyint
(
  COL_NUMBER    numeric not null,
  COL_TINYINT1   TINYINT,
  COL_TINYINT2   TINYINT,
  COL_TINYINT3   TINYINT,
  COL_TINYINT4   TINYINT,
  COL_TINYINT5   TINYINT,
PRIMARY KEY(COL_NUMBER)
)
go
