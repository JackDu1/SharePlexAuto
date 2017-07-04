use sp_ss
IF OBJECT_ID('sp_ss.qa_timestamp', 'U') IS NOT NULL
drop table sp_ss.qa_timestamp
go
create table sp_ss.qa_timestamp
(
  COL_NUMBER       numeric(25,2) not null,
  COL_TIMESTAMP1   datetimeoffset(4),
  COL_TIMESTAMP2   datetime2(6),
  COL_TIMESTAMP3   datetimeoffset(3),
  COL_TIMESTAMP4   datetime2(2),
  COL_TIMESTAMP5   datetimeoffset(5),
  COL_TIMESTAMP6   datetime2(7),
  COL_TIMESTAMP7   datetimeoffset(6),
  COL_TIMESTAMP8   datetime2(7),
  COL_TIMESTAMP9   datetimeoffset(7),
  COL_TIMESTAMP10  datetimeoffset(7),
PRIMARY KEY(COL_NUMBER)
)
go

