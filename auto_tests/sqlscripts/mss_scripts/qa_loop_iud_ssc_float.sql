SET NOCOUNT ON
use sp_ss
go
begin
delete from sp_ss.ssc_float
end
declare @i int
set @i=1
while @i<10001
begin 
insert into sp_ss.ssc_float values (
@i,
rand()*99999,
rand()*999999999,
rand()*999999999999999,
rand()*9999999999999999999,
rand()*999999999999999999999999,
rand()*9999999999999999999999999999999)
set @i=@i+1
end
while @i<20001
begin 
insert into sp_ss.ssc_float values (
@i,
-rand()*99999,
-rand()*999999999,
-rand()*999999999999999,
-rand()*9999999999999999999,
-rand()*999999999999999999999999,
-rand()*9999999999999999999999999999999)
set @i=@i+1
end
declare @u int
set @u=1
while @u<10001
begin 
update sp_ss.ssc_float set 
COL2=rand()*1,
COL3=rand()*111,
COL4=rand()*3333,
COL5=rand()*999999,
COL6=rand()*5555,
COL7=rand()*66666666666
WHERE COL1=@u
set @u=@u+1
end
declare @k int
set @k=1
while @k<600
begin 
delete from sp_ss.ssc_float where COL1 in (@k+500,10000-@k,4000+@k)
set @k=@k+1
end
go
SET NOCOUNT OFF
