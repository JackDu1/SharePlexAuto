SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_decimal
declare @i int
set @i=1
begin tran
while @i<1001
begin
insert into sp_ss.ssc_decimal values (
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
insert into sp_ss.ssc_decimal values (
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
delete from sp_ss.ssc_decimal where COL1=@i-1000
set @i=@i+1
end
rollback tran B
while @i<5001
begin
insert into sp_ss.ssc_decimal values (
@i,
floor(rand()*1.9) ,
floor(rand()*255),
floor(rand()*32767),
floor(rand()*9999999999999),
@Decimal,
@numeric-@i,
rand()*9999999999999,
rand()*99999)
set @i=@i+1
set @Decimal=@Decimal+@i
set @numeric=@numeric-@i
end
rollback tran A
commit tran
go
SET NOCOUNT OFF
