SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_varchar
declare @i int
set @i=1
begin tran
while @i<10001
begin 
insert into sp_ss.ssc_varchar values (
@i,
left(replicate(newid(), 14),500),
left(replicate(rand()*9999999999,340),1000),
right(replicate(convert(varchar(30),getDate(),100),211),1001),
replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),500),
replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),1000),
replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),2000)
)
set @i=@i+1
end
save tran A
while @i<20001
begin
insert into sp_ss.ssc_varchar values (
@i,
left(replicate(newid(), 14),500),
left(replicate(rand()*9999999999,340),1000),
right(replicate(convert(varchar(30),getDate(),100),211),1001),
replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),500),
replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),1000),
replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),2000)
)
set @i=@i+1
end
save tran B
while @i<30001
begin
delete from sp_ss.ssc_varchar where COL_NUMBER=@i-10000
set @i=@i+1
end
rollback tran B
while @i<50001
begin
insert into sp_ss.ssc_varchar values (
@i,
left(replicate(newid(), 14),500),
left(replicate(rand()*9999999999,340),1000),
right(replicate(convert(varchar(30),getDate(),100),211),1001),
replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),500),
replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),1000),
replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),2000)
)
set @i=@i+1
end
save tran C
while @i<60001
begin
insert into sp_ss.ssc_varchar values (
@i,
left(replicate(newid(), 14),500),
left(replicate(rand()*9999999999,340),1000),
right(replicate(convert(varchar(30),getDate(),100),211),1001),
replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),500),
replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),1000),
replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),2000)
)
set @i=@i+1
end
rollback tran A
commit tran
go
SET NOCOUNT OFF
