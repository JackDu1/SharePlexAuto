use sp_ss
IF OBJECT_ID('sp_ss.ssc_datetimeoffset', 'U') IS NOT NULL
drop table sp_ss.ssc_datetimeoffset
go
create table sp_ss.ssc_datetimeoffset
(
    COL_NUMBER numeric(25,2) PRIMARY KEY,
    COL0 datetimeoffset(0),
    COL1 datetimeoffset(1),
    COL2 datetimeoffset(2),
    COL3 datetimeoffset(3),
    COL4 datetimeoffset(4),
    COL5 datetimeoffset(5),
    COL6 datetimeoffset(6),
    COL7 datetimeoffset(7)
)
go
