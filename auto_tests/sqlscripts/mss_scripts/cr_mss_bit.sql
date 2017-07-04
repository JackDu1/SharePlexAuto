use sp_ss
IF OBJECT_ID('sp_ssc.mss_bit', 'U') IS NOT NULL
drop table sp_ssc.mss_bit
go
create table sp_ssc.mss_bit
(
  COL_NUMBER    numeric not null,
  COL_BIT1   BIT,
  COL_BIT2   BIT,
  COL_BIT3   BIT,
  COL_BIT4   BIT,
  COL_BIT5   BIT,
PRIMARY KEY(COL_NUMBER)
)
go
