use sp_ss

IF OBJECT_ID('sp_ssc.mss_time', 'U') IS NOT NULL
drop table sp_ssc.mss_time
go
create table sp_ssc.mss_time
(
  COL_NUMBER    numeric not null,
  COL_TIME1   TIME(0),
  COL_TIME2   TIME(2),
  COL_TIME3   TIME(4),
  COL_TIME4   TIME(7),
  COL_TIME5   TIME,
PRIMARY KEY(COL_NUMBER)
)
go



IF OBJECT_ID('sp_ssc.mss_date', 'U') IS NOT NULL
drop table sp_ssc.mss_date
go
create table sp_ssc.mss_date
(
  COL_NUMBER    numeric not null,
  COL_DATE1   DATE,
  COL_DATE2   DATE,
  COL_DATE3   DATE,
  COL_DATE4   DATE,
  COL_DATE5   DATE,
PRIMARY KEY(COL_NUMBER)
)
go





IF OBJECT_ID('sp_ssc.mss_smalldatetime', 'U') IS NOT NULL
drop table sp_ssc.mss_smalldatetime
go
create table sp_ssc.mss_smalldatetime
(
  COL_NUMBER    numeric not null,
  COL_SMALLDATETIME1   SMALLDATETIME,
  COL_SMALLDATETIME2   SMALLDATETIME,
  COL_SMALLDATETIME3   SMALLDATETIME,
  COL_SMALLDATETIME4   SMALLDATETIME,
  COL_SMALLDATETIME5   SMALLDATETIME,
PRIMARY KEY(COL_NUMBER)
)
go



IF OBJECT_ID('sp_ssc.mss_datetime', 'U') IS NOT NULL
drop table sp_ssc.mss_datetime
go
create table sp_ssc.mss_datetime
(
  COL_NUMBER    numeric not null,
  COL_DATETIME1   DATETIME,
  COL_DATETIME2   DATETIME,
  COL_DATETIME3   DATETIME,
  COL_DATETIME4   DATETIME,
  COL_DATETIME5   DATETIME,
PRIMARY KEY(COL_NUMBER)
)
go


IF OBJECT_ID('sp_ssc.mss_datetime2', 'U') IS NOT NULL
drop table sp_ssc.mss_datetime2
go
create table sp_ssc.mss_datetime2
(
  COL_NUMBER    numeric not null,
  COL_DATETIME21   DATETIME2,
  COL_DATETIME22   DATETIME2,
  COL_DATETIME23   DATETIME2,
  COL_DATETIME24   DATETIME2,
  COL_DATETIME25   DATETIME2,
PRIMARY KEY(COL_NUMBER)
)
go


IF OBJECT_ID('sp_ssc.mss_datetimeoffset', 'U') IS NOT NULL
drop table sp_ssc.mss_datetimeoffset
go
create table sp_ssc.mss_datetimeoffset
(
  COL_NUMBER    numeric not null,
  COL_DATETIMEOFFSET1   DATETIMEOFFSET,
  COL_DATETIMEOFFSET2   DATETIMEOFFSET,
  COL_DATETIMEOFFSET3   DATETIMEOFFSET,
  COL_DATETIMEOFFSET4   DATETIMEOFFSET,
  COL_DATETIMEOFFSET5   DATETIMEOFFSET,
PRIMARY KEY(COL_NUMBER)
)
go