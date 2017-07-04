use sp_ss
IF OBJECT_ID('sp_ss.ssc_date', 'U') IS NOT NULL
drop table sp_ss.ssc_date
go
create table sp_ss.ssc_date 
(
    COL_NUMBER numeric(25,2) PRIMARY KEY,
    COL_DATE1 date,
    COL_DATE2 datetime,
    COL_DATE3 datetime2,
    COL_DATE4 datetimeoffset,
    COL_DATE5 smalldatetime,
    COL_DATE6 time
)
go
