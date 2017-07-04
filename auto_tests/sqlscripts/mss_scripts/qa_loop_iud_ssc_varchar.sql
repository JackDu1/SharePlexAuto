SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_varchar
declare @i int
set @i=1
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
declare @u int
set @u=1
while @u<10001
begin 
update sp_ss.ssc_varchar set 
COL_VARCHAR1=left(replicate(newid(), 14),500),
COL_VARCHAR2=left(replicate(rand()*9999999999,340),1000),
COL_VARCHAR3=right(replicate(convert(varchar(30),getDate(),100),211),1001),
COL_VARCHAR4=replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),1000),
COL_VARCHAR5=replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),2000),
COL_VARCHAR6=replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),2000)
WHERE COL_NUMBER=@u
set @u=@u+1
end
declare @k int
set @k=1
while @k<600
begin 
delete from sp_ss.ssc_varchar where COL_NUMBER in (@k+500,10000-@k,4000+@k)
set @k=@k+1
end
go
SET NOCOUNT OFF
