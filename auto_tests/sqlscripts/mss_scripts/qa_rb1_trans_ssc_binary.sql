SET NOCOUNT ON
use sp_ss
go
Delete from sp_ss.ssc_binary
delete from sp_ss.ssc_varbinary
Declare @i int
Set @i=1
Begin TRAN
While @i<1001
Begin
Insert into sp_ss.ssc_binary values(
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
save tran A
While @i<2001
Begin
Insert into sp_ss.ssc_binary values(
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
Rollback TRAN A
commit tran
SET NOCOUNT OFF
