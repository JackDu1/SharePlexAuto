SET NOCOUNT ON
use sp_ss
delete from sp_ss.ssc_float
go
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
SET NOCOUNT OFF
