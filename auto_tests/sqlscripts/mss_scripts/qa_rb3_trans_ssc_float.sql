SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_float
declare @i int
set @i=1
begin tran
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
save tran A
while @i<20001
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
save tran B
while @i<30001
begin
delete from sp_ss.ssc_float where COL1=@i-10000
set @i=@i+1
end
rollback tran B
while @i<50001
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
save tran C
while @i<60001
begin
update sp_ss.ssc_float set
COL2=rand()*99999,
COL3=rand()*999999999,
COL4=rand()*999999999999999,
COL5=rand()*9999999999999999999,
COL6=rand()*999999999999999999999999,
COL7=rand()*9999999999999999999999999999999
where COL1=@i-5000
set @i=@i+1
end
rollback tran A
commit tran
go
SET NOCOUNT OFF
