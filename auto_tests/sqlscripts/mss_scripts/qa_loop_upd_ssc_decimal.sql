SET NOCOUNT ON
use sp_ss
go
declare @i int
set @i=1
while @i<10001
begin  
update sp_ss.ssc_decimal set
COL2=floor(rand()*99999999999999999999999)+convert(float,round(rand()*1,7)),
COL3=floor(rand()*999999999999999999999999999999)+convert(float,round(rand()*1,4)),
COL4=floor(rand()*999999999999999999999999999999999)+convert(float,round(rand()*1,3)),
COL5=floor(rand()*999999999999999999999999999999999999)+convert(float,round(rand()*1,1)),
COL6=convert(float,round((rand()*1)/10000000000000000000000,38)),
COL7=floor(rand()*999)+convert(float,round(rand()*1,9))
WHERE COL1=@i
set @i=@i+1
end
go
SET NOCOUNT OFF
