SET NOCOUNT ON
use sp_ss
go
declare @i int
Set @i=1
begin TRAN
While @i<1001
begin
Update sp_ss.ssc_binary set 
COL_BINARY=cast(floor(rand()*100000000000000000) as binary),
COL_BINARY1=cast(floor(rand()*100000000000000001) as binary),
COL_BINARY2=cast(floor(rand()*100000000000000001) as binary),
COL_BINARY3=cast(floor(rand()*100000000000000001) as binary)
where COL_NUMBER=@i
set @i=@i+1
end
commit TRAN
declare @u int
set @u=1
Begin TRAN
While @u<1001
Begin
Update sp_ss.ssc_varbinary set
COL2=convert(varbinary(100),replicate(floor(rand()*99999),10)),
COL3=convert(varbinary(500),replicate(floor(rand()*99999),100)),
COL4=convert(varbinary(1000),replicate(floor(rand()*99999),200)),
COL5=convert(varbinary(2000),replicate(floor(rand()*99999),400)),
COL6=convert(varbinary(3000),replicate(floor(rand()*99999),600)),
COL7=convert(varbinary(max),replicate(floor(rand()*99999),1000))
WHERE COL1=@u
set @u=@u+1
end
SET NOCOUNT OFF
