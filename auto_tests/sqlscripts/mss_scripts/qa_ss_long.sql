use sp_ss
IF OBJECT_ID('sp_ss.qa_long', 'U') IS NOT NULL
drop table sp_ss.qa_long
go
create table sp_ss.qa_long
(
  COL_NUMBER   numeric(25,2) not null,
  COL_LONG     text,
PRIMARY KEY(COL_NUMBER)
)
go

