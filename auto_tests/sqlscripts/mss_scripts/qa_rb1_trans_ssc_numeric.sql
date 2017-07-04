SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_numeric
declare @i int
set @i=1
begin tran
while @i<1001
begin
insert into sp_ss.ssc_numeric values (
@i,
floor(rand()*1.9) ,
floor(rand()*255),
floor(rand()*32767),
floor(rand()*9999999999999999))
set @i=@i+1
end
save tran A
while @i<2001
begin
insert into sp_ss.ssc_numeric values (
@i,
floor(rand()*1.9) ,
floor(rand()*255),
floor(rand()*32767),
floor(rand()*9999999999999999))
set @i=@i+1
end
save tran B
while @i<3001
begin
delete from sp_ss.ssc_numeric where COL1=@i-1000
set @i=@i+1
end
rollback tran A
commit tran
go
SET NOCOUNT OFF

