use sp_ss
IF OBJECT_ID('sp_ss.qa_number_max', 'U') IS NOT NULL
drop table sp_ss.qa_number_max
go
create table sp_ss.qa_number_max
(
  COL_NUMBER    numeric(25,2) not null,
  COL_NUMBER1 numeric(38,0),
  COL_NUMBER2 numeric(38,0),
  COL_NUMBER3 numeric(38,0),
  COL_NUMBER4 numeric(38,0),
  PRIMARY KEY(COL_NUMBER)
)
go

