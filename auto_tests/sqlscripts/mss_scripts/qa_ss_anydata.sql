use sp_ss
IF OBJECT_ID('sp_ss.qa_anydata_char', 'U') IS NOT NULL
drop table sp_ss.qa_anydata_char
go
create table sp_ss.qa_anydata_char
(
  COL_NUMBER          numeric(25,2) not null,
  COL_ANYDATA_CHAR1   sql_variant,
  COL_ANYDATA_CHAR2   sql_variant,
  COL_ANYDATA_CHAR3   sql_variant,
  COL_ANYDATA_CHAR4   sql_variant,
  COL_ANYDATA_CHAR5   sql_variant
PRIMARY KEY(COL_NUMBER)
)
go

IF OBJECT_ID('sp_ss.qa_anydata_number', 'U') IS NOT NULL
drop table sp_ss.qa_anydata_number
go
create table sp_ss.qa_anydata_number
(
  COL_NUMBER          numeric(25,2) not null,
  COL_ANYDATA_NUMBER1   sql_variant,
  COL_ANYDATA_NUMBER2   sql_variant,
  COL_ANYDATA_NUMBER3   sql_variant,
  COL_ANYDATA_NUMBER4   sql_variant,
  COL_ANYDATA_NUMBER5   sql_variant
PRIMARY KEY(COL_NUMBER)
)
go

IF OBJECT_ID('sp_ss.qa_anydata_date', 'U') IS NOT NULL
drop table sp_ss.qa_anydata_date
go
create table sp_ss.qa_anydata_date
(
  COL_NUMBER          numeric(25,2) not null,
  COL_ANYDATA_DATE1   sql_variant,
  COL_ANYDATA_DATE2   sql_variant,
  COL_ANYDATA_DATE3   sql_variant,
  COL_ANYDATA_DATE4   sql_variant,
  COL_ANYDATA_DATE5   sql_variant
PRIMARY KEY(COL_NUMBER)
)
go

IF OBJECT_ID('sp_ss.qa_anydata_raw', 'U') IS NOT NULL
drop table sp_ss.qa_anydata_raw
go
create table sp_ss.qa_anydata_raw
(
  COL_NUMBER         numeric(25,2) not null,
  COL_ANYDATA_RAW1   sql_variant,
  COL_ANYDATA_RAW2   sql_variant,
  COL_ANYDATA_RAW3   sql_variant,
  COL_ANYDATA_RAW4   sql_variant,
  COL_ANYDATA_RAW5   sql_variant
PRIMARY KEY(COL_NUMBER)
)
go

IF OBJECT_ID('sp_ss.qa_anydata_varchar', 'U') IS NOT NULL
drop table sp_ss.qa_anydata_varchar2
go
create table sp_ss.qa_anydata_varchar2
(
  COL_NUMBER               numeric(25,2) not null,
  COL_ANYDATA_VARCHAR2_1   sql_variant,
  COL_ANYDATA_VARCHAR2_2   sql_variant,
  COL_ANYDATA_VARCHAR2_3   sql_variant,
  COL_ANYDATA_VARCHAR2_4   sql_variant,
  COL_ANYDATA_VARCHAR2_5   sql_variant
PRIMARY KEY(COL_NUMBER)
)
go

IF OBJECT_ID('sp_ss.qa_anydata_timestamp', 'U') IS NOT NULL
drop table sp_ss.qa_anydata_timestamp
go
create table sp_ss.qa_anydata_timestamp
(
  COL_NUMBER               numeric(25,2) not null,
  COL_ANYDATA_TIMESTAMP1   sql_variant,
  COL_ANYDATA_TIMESTAMP2   sql_variant,
  COL_ANYDATA_TIMESTAMP3   sql_variant,
  COL_ANYDATA_TIMESTAMP4   sql_variant,
  COL_ANYDATA_TIMESTAMP5   sql_variant,
  COL_ANYDATA_TIMESTAMP6   sql_variant,
  COL_ANYDATA_TIMESTAMP7   sql_variant,
  COL_ANYDATA_TIMESTAMP8   sql_variant,
  COL_ANYDATA_TIMESTAMP9   sql_variant,
  COL_ANYDATA_TIMESTAMP10  sql_variant
PRIMARY KEY(COL_NUMBER)
)
go


