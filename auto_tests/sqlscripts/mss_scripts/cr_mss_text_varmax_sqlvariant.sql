use sp_ss

IF OBJECT_ID('sp_ssc.mss_text', 'U') IS NOT NULL
drop table sp_ssc.mss_text
go
create table sp_ssc.mss_text
(
  COL_NUMBER    numeric not null,
  COL_TEXT1   TEXT,
  COL_TEXT2   TEXT,
  COL_TEXT3   TEXT,
  COL_TEXT4   TEXT,
  COL_TEXT5   TEXT,
PRIMARY KEY(COL_NUMBER)
)
go



IF OBJECT_ID('sp_ssc.mss_varchar_max', 'U') IS NOT NULL
drop table sp_ssc.mss_varchar_max
go
create table sp_ssc.mss_varchar_max
(
  COL_NUMBER    numeric not null,
  COL_VARCHAR_MAX1   VARCHAR(max),
  COL_VARCHAR_MAX2   VARCHAR(max),
  COL_VARCHAR_MAX3   VARCHAR(max),
  COL_VARCHAR_MAX4   VARCHAR(max),
  COL_VARCHAR_MAX5   VARCHAR(max),
PRIMARY KEY(COL_NUMBER)
)
go



IF OBJECT_ID('sp_ssc.mss_sql_variant', 'U') IS NOT NULL
drop table sp_ssc.mss_sql_variant
go
create table sp_ssc.mss_sql_variant
(
  COL_NUMBER    numeric not null,
  COL_SQL_VARIANT1   SQL_VARIANT,
  COL_SQL_VARIANT2   SQL_VARIANT,
  COL_SQL_VARIANT3   SQL_VARIANT,
  COL_SQL_VARIANT4   SQL_VARIANT,
  COL_SQL_VARIANT5   SQL_VARIANT,
PRIMARY KEY(COL_NUMBER)
)
go


