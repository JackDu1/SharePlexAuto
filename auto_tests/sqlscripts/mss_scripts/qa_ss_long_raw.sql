use sp_ss
IF OBJECT_ID('sp_ss.qa_long_raw', 'U') IS NOT NULL
drop table sp_ss.qa_long_raw
go
create table sp_ss.qa_long_raw
(
  COL_NUMBER      numeric(25,2) not null,
  COL_LONG_RAW    image,
PRIMARY KEY(COL_NUMBER)
)
go

