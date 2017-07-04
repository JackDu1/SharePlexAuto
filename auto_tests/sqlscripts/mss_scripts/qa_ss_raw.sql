use sp_ss
IF OBJECT_ID('sp_ss.qa_raw', 'U') IS NOT NULL
drop table sp_ss.qa_raw
go
create table sp_ss.qa_raw
(
  COL_NUMBER   numeric(25,2) not null,
  COL_RAW1     varbinary(100),
  COL_RAW2     varbinary(200),
  COL_RAW3     varbinary(500),
  COL_RAW4     varbinary(1500),
  COL_RAW5     varbinary(2000),
PRIMARY KEY(COL_NUMBER)
)
go

