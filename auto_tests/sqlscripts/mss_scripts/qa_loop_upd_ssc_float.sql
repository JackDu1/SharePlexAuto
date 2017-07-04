SET NOCOUNT ON
use sp_ss
go
declare @i int
set @i=1
while @i<10001
begin 
update sp_ss.ssc_float set
COL2=rand()*1,
COL3=rand()*2,
COL4=rand()*3,
COL5=rand()*4,
COL6=rand()*5,
COL7=rand()*6
WHERE COL1=@i
set @i=@i+1
end
go
SET NOCOUNT OFF
