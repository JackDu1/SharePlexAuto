SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.qa_binary
declare @i int
set @i=1
Begin TRAN
While @i<2001
Begin
Insert into sp_ss.qa_binary values(
@i,
cast(floor(rand()*100000000000000000) as binary),
cast(floor(rand()*100000000000000001) as binary),
cast(floor(rand()*112000000000000000) as binary),
cast(floor(rand()*134000000000000000) as binary))
Insert into sp_ss.ssc_varbinary values(
@i,
convert(varbinary(100),replicate(floor(rand()*99999),10)),
convert(varbinary(500),replicate(floor(rand()*99999),100)),
convert(varbinary(1000),replicate(floor(rand()*99999),200)),
convert(varbinary(2000),replicate(floor(rand()*99999),400)),
convert(varbinary(3000),replicate(floor(rand()*99999),600)),
convert(varbinary(max),replicate(floor(rand()*99999),1000)))
Set @i=@i +1 
End
commit TRAN
declare @u int
Set @u=1
begin TRAN
While @u<1001
begin
Update sp_ss.qa_binary set 
COL_BINARY=cast(floor(rand()*100000000000000000) as binary),
COL_BINARY1=cast(floor(rand()*100000000000000001) as binary),
COL_BINARY2=cast(floor(rand()*100000000000000001) as binary),
COL_BINARY3=cast(floor(rand()*100000000000000001) as binary)
where COL_NUMBER=@u
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
commit TRAN
begin 
delete from sp_ss.ssc_binary where COL_NUMBER<950
delete from sp_ss.ssc_varbinary where COL1<950
end
go
SET NOCOUNT OFF
