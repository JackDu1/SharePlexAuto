SET NOCOUNT ON
use sp_ss
delete from sp_ss.ssc_int
go
declare @i int
set @i=1
while @i<10001
begin 
insert into sp_ss.ssc_int values (
@i,
floor(rand()*1.1),
floor(rand()*255),
32768-@i,
92233720368547758-@i)
set @i=@i+1
end
while @i<20001
begin 
insert into sp_ss.ssc_int values (
@i,
floor(rand()*1.1),
floor(rand()*255),
32768-@i,
-9223372036855809+@i-10000)
set @i=@i+1
end
go
SET NOCOUNT OFF
