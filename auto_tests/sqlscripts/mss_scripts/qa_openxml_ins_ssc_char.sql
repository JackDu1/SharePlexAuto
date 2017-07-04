SET NOCOUNT ON
use sp_ss
go
Delete from sp_ss.ssc_char_all
Delete from sp_ss.ssc_nchar_all
Declare @i int
Set @i=1

bulk insert sp_ss.ssc_char_all from '/qa/splex/common/load/bcp/ssc_char_nu1.bcp' with (FIELDTERMINATOR = '    z', ROWTERMINATOR ='\n')

bulk insert sp_ss.ssc_nchar_all from '/qa/splex/common/load/bcp/ssc_nchar_nu1.bcp' with (FIELDTERMINATOR = '    z', ROWTERMINATOR ='\n')

While @i<3
Begin
Update sp_ss.ssc_char_all set
COL_CHAR2= (select bulkcolumn from openrowset(bulk '/qa/splex/common/load/bcp/ssc_charxml1.xml',SINGLE_CLOB) as a),
COL_VARCHAR2=(select bulkcolumn from openrowset(bulk '/qa/splex/common/load/bcp/ssc_charxml1.xml',SINGLE_CLOB) as a),
COL_VARCHAR3= (select bulkcolumn from openrowset(bulk '/qa/splex/common/load/bcp/ssc_charxml1.xml',SINGLE_CLOB) as a) 
where COL_NUMBER=@i 

Update sp_ss.ssc_nchar_all set
COL_NCHAR1= (select bulkcolumn from openrowset(bulk '/qa/splex/common/load/bcp/ssc_ncharxml1.xml',SINGLE_NCLOB) as a),
COL_NVARCHAR1=(select bulkcolumn from openrowset(bulk '/qa/splex/common/load/bcp/ssc_ncharxml2.xml',SINGLE_NCLOB) as a),
COL_NVARCHAR2= (select bulkcolumn from openrowset(bulk '/qa/splex/common/load/bcp/ssc_ncharxml2.xml',SINGLE_NCLOB) as a) ,
COL_TEXT=(select bulkcolumn from openrowset(bulk '/qa/splex/common/load/bcp/ssc_charxml1.xml',SINGLE_CLOB) as a)  ,
COL_NTEXT=(select bulkcolumn from openrowset(bulk '/qa/splex/common/load/bcp/ssc_ncharxml2.xml',SINGLE_NCLOB) as a)  
where COL_NUMBER= @i

Set @i=@i+1
end
