use sp_ss
IF OBJECT_ID('sp_ss.qa_integer', 'U') IS NOT NULL
drop table sp_ss.qa_integer
go
create table sp_ss.qa_integer
(
  COL_NUMBER     numeric(25,2) not null,
  COL_INTEGER1   int,
  COL_INTEGER2   int,
  COL_INTEGER3   int,
  COL_INTEGER4   int,
  COL_INTEGER5   int,
PRIMARY KEY(COL_NUMBER)
)
go
