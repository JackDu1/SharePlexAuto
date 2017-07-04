use sp_ss
IF OBJECT_ID('sp_ss.ssc_time', 'U') IS NOT NULL
drop table sp_ss.ssc_time
go
create table sp_ss.ssc_time
(
    COL_NUMBER numeric(25,2) PRIMARY KEY,
    COL0 time(0),
    COL1 time(1),
    COL2 time(2),
    COL3 time(3),
    COL4 time(4),
    COL5 time(5),
    COL6 time(6),
    COL7 time(7)
)
go
