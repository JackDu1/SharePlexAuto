SET NOCOUNT ON
use sp_ss
go
begin
delete from sp_ss.ssc_decimal
end
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
declare @u int
set @u=1
while @u<10001
begin
update sp_ss.ssc_decimal set
COL2=floor(rand()*99999999999999999999999)+convert(float,round(rand()*1,7)),
COL3=floor(rand()*999999999999999999999999999999)+convert(float,round(rand()*1,4)),
COL4=floor(rand()*999999999999999999999999999999999)+convert(float,round(rand()*1,3)),
COL5=floor(rand()*999999999999999999999999999999999999)+convert(float,round(rand()*1,1)),
COL6=convert(float,round((rand()*1)/10000000000000000000000,38)),
COL7=floor(rand()*999)+convert(float,round(rand()*1,9))
WHERE COL1=@u
set @u=@u+1
end
declare @k int
set @k=1
while @k<600
begin
delete from sp_ss.ssc_decimal where COL1 in (@k+500,10000-@k,4000+@k)
set @k=@k+1
end
go
SET NOCOUNT OFF
