SET NOCOUNT ON
use sp_ss
go

Delete from sp_ss.ssc_binary_all
Declare @i int
Set @i=1

While @i< 2001
Begin
Insert into sp_ss.ssc_binary_all select @i+1,a.*,a.*,a.*,a.*,a.*,a.* 
from openrowset(bulk '/qa/splex/common/load/bcp/ssc_image1.png',SINGLE_BLOB) as a 
Set @i=@i+1
End

While @i<4001
Begin
Insert into sp_ss.ssc_binary_all select @i+1 ,'',a.*,a.*,a.*,a.*,convert(varbinary,'')  from openrowset(bulk '/qa/splex/common/load/bcp/ssc_image1.png',SINGLE_BLOB) as a

update sp_ss.ssc_binary_all set 
COL_IMAGE=(select bulkcolumn from openrowset(bulk '/qa/splex/common/load/bcp/ssc_image3.png',SINGLE_BLOB) as a),
COL_VARBINARY2=(select bulkcolumn from openrowset(bulk '/qa/splex/common/load/bcp/ssc_image3.png',SINGLE_BLOB) as a) 
where COL_NUMBER = @i

Set @i=@i+1
End

While @i < 6001
Begin
Insert into sp_ss.ssc_binary_all select @i+1 ,a.*,convert(varbinary,''),convert(varbinary,''),convert(varbinary,''),convert(varbinary,''),a.*  from openrowset(bulk '/qa/splex/common/load/bcp/ssc_image3.png',SINGLE_BLOB) as a 

update sp_ss.ssc_binary_all set 
COL_BINARY=(select bulkcolumn from openrowset(bulk '/qa/splex/common/load/bcp/ssc_image1.png',SINGLE_BLOB) as a),
COL_BINARY1=(select bulkcolumn from openrowset(bulk '/qa/splex/common/load/bcp/ssc_image2.png',SINGLE_BLOB) as a),
COL_VARBINARY=(select bulkcolumn from openrowset(bulk '/qa/splex/common/load/bcp/ssc_image1.png',SINGLE_BLOB) as a),
COL_VARBINARY1=(select bulkcolumn from openrowset(bulk '/qa/splex/common/load/bcp/ssc_image1.png',SINGLE_BLOB) as a) 
where COL_NUMBER=@i
Set @i=@i+1
End
go
SET NOCOUNT OFF
