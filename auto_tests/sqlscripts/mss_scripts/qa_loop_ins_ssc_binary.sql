SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_binary
declare @i int
set @i=1
Begin TRAN
While @i<2001
Begin
Insert into sp_ss.ssc_binary values(
@i,
cast(floor(rand()*100000000000000000) as binary),
cast(floor(rand()*100000000000000001) as binary),
cast(floor(rand()*112000000000000000) as binary),
cast(floor(rand()*134000000000000000) as binary))
Set @i=@i +1 
End
commit TRAN
delete from sp_ss.ssc_varbinary
declare @u int
set @u=1
Begin TRAN
While @u<1001
Begin
Insert into sp_ss.ssc_varbinary values(
@u,
convert(varbinary(100),replicate(floor(rand()*99999),20)), 
convert(varbinary(500),replicate(floor(rand()*99999),100)), 
convert(varbinary(1000),replicate(floor(rand()*99999),200)), 
convert(varbinary(2000),replicate(floor(rand()*99999),400)), 
convert(varbinary(3000),replicate(floor(rand()*99999),600)), 
convert(varbinary(max),replicate(floor(rand()*99999),1600))) 
set @u=@u+1
end
commit tran
go
