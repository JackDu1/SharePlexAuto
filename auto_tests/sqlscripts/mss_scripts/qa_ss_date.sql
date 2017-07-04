use sp_ss
IF OBJECT_ID('sp_ss.qa_date_gt1753', 'U') IS NOT NULL
drop table sp_ss.qa_date_gt1753
go
create table sp_ss.qa_date_gt1753
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DATE1   datetime,
  COL_DATE2   datetime,
  COL_DATE3   datetime,
  COL_DATE4   datetime,
  COL_DATE5   datetime,
PRIMARY KEY(COL_NUMBER)
)
go

----------------------------
IF OBJECT_ID('sp_ss.qa_date_lt1753', 'U') IS NOT NULL
drop table sp_ss.qa_date_lt1753
go
create table sp_ss.qa_date_lt1753
(
  COL_NUMBER  numeric(25,2) not null,
  COL_DATE1   datetime2(7),
  COL_DATE2   datetime2(7),
  COL_DATE3   datetime2(7),
  COL_DATE4   datetime2(7),
  COL_DATE5   datetime2(7),
PRIMARY KEY(COL_NUMBER)
)
go
