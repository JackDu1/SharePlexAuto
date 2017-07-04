use sp_ss
IF OBJECT_ID('sp_ss.qa_clob_ltgt4k', 'U') IS NOT NULL
drop table sp_ss.qa_clob_ltgt4k
go
create table sp_ss.qa_clob_ltgt4k
(
  COL_NUMBER  numeric(25,2) not null,
  COL_CLOB1   text,
  COL_CLOB2   text,
  COL_CLOB3   text,
  COL_CLOB4   text,
  COL_CLOB5   text,
PRIMARY KEY(COL_NUMBER)
)
go

