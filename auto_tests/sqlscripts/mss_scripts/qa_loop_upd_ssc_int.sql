SET NOCOUNT ON
use sp_ss
go
declare @i int
set @i=1
while @i<10001
begin 
update sp_ss.ssc_int set 
COL2=floor(rand()*1.9),
COL3=floor(rand()*255),
COL4=1111-@i,
COL5=1111111111-@i
WHERE COL1=@i
set @i=@i+1
end
go
SET NOCOUNT OFF
