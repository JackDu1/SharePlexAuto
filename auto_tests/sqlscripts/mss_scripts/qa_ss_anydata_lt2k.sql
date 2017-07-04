use sp_ss
IF OBJECT_ID('sp_ss.qa_anydata_lt2k', 'U') IS NOT NULL
drop table sp_ss.qa_anydata_lt2k
go
create table sp_ss.qa_anydata_lt2k
(
  COL_NUMBER     numeric(27,2) not null,
  COL_ANYDATA1   sql_variant,
  COL_ANYDATA2   sql_variant,
  COL_ANYDATA3   sql_variant,
  COL_ANYDATA4   sql_variant,
  COL_ANYDATA5   sql_variant,
  COL_ANYDATA6   sql_variant,
PRIMARY KEY(COL_NUMBER)
)
go

