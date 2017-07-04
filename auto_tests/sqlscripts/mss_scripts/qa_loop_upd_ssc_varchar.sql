SET NOCOUNT ON
use sp_ss
go
declare @i int
set @i=1
while @i<3000
begin 
update sp_ss.ssc_varchar set 
COL_VARCHAR1=left(replicate(newid(), 14),500),
COL_VARCHAR2=left(replicate(rand()*9999999999,340),1000),
COL_VARCHAR3=right(replicate(convert(varchar(30),getDate(),100),211),1001),
COL_VARCHAR4=replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),1000),
COL_VARCHAR5=replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),2000),
COL_VARCHAR6=replicate(lower(char(65+ceiling(rand()*25)))+upper(char(65+ceiling(rand()*25)))+right(rand(),1),2500)
WHERE COL_NUMBER=@i
set @i=@i+1
end
SET NOCOUNT OFF
