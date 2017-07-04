SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_decimal
declare @i int
set @i=1
while @i<10001
begin  
insert into sp_ss.ssc_decimal values (
@i,
floor(rand()*99999999999999999999999)+convert(float,round(rand()*1,7)),
floor(rand()*999999999999999999999999999999)+convert(float,round(rand()*1,4)),
floor(rand()*999999999999999999999999999999999)+convert(float,round(rand()*1,3)),
floor(rand()*999999999999999999999999999999999999)+convert(float,round(rand()*1,1)),
convert(float,round((rand()*1)/10000000000000000000000,38)),
floor(rand()*999)+convert(float,round(rand()*1,9)))
set @i=@i+1
end
go
SET NOCOUNT OFF
