SET NOCOUNT ON
use sp_ss
go
begin
delete from sp_ss.ssc_int
end
declare @i int
set @i=1
while @i<10001
begin 
insert into sp_ss.ssc_int values (
@i,
floor(rand()*1.1),
floor(rand()*255),
32768-@i,
9223372036854775808-@i)
set @i=@i+1
end
while @i<20001
begin 
insert into sp_ss.int values (
@i,
floor(rand()*1.1),
floor(rand()*255),
32768-@i,
-9223372036854775809+@i-10000)
set @i=@i+1
end
declare @u int
set @u=1
while @u<10001
begin 
update sp_ss.ssc_int set 
COL2=floor(rand()*1.9),
COL3=floor(rand()*255),
COL4=1111-@u,
COL5=1111111111-@u
WHERE COL1=@u
set @u=@u+1
end
declare @k int
set @k=1
while @k<600
begin 
delete from sp_ss.ssc_int where COL1 in (@k+500,10000-@k,4000+@k)
set @k=@k+1
end
go
SET NOCOUNT OFF
