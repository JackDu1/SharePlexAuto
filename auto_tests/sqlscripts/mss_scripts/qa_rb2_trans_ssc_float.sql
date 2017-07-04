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
rand()*99999 ,
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
rand()*99999 ,
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
insert into sp_ss.ssc_float values (
@i,
rand()*99999 ,
rand()*999999999,
rand()*999999999999999,
rand()*9999999999999999999,
rand()*999999999999999999999999,
rand()*9999999999999999999999999999999)
set @i=@i+1
end
rollback tran B
commit tran
go
SET NOCOUNT OFF
