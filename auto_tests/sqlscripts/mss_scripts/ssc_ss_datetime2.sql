use sp_ss
IF OBJECT_ID('sp_ss.ssc_datetime2', 'U') IS NOT NULL
drop table sp_ss.ssc_datetime2
go
create table sp_ss.ssc_datetime2
(
    COL_NUMBER numeric(25,2) PRIMARY KEY,
    COL0 datetime2(0),
    COL1 datetime2(1),
    COL2 datetime2(2),
    COL3 datetime2(3),
    COL4 datetime2(4),
    COL5 datetime2(5),
    COL6 datetime2(6),
    COL7 datetime2(7)
)
go
