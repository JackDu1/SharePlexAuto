SET NOCOUNT ON
use sp_ss
go
Delete from sp_ss.ssc_nchar
Delete from sp_ss.ssc_nchar_max
Declare @v_count int
 Declare @v_text1 nvarchar(max),@v_text2 nvarchar(max),@v_text3 nvarchar(max),@v_text4 nvarchar(max)
set @v_text1 = 'qawertyugdd34t5ugj;xcnmgiqt© 9§3u53u7-5ekgbb¥nhsfh-054µ6934-7KJFSDGB;NM';
set @v_text2 = ',bsfk095t6i3m,bßk hmyÂ3utejgklfdklfdgkn6-yifl;hm¿vxcmgakg46095½86-0u8bknbn.z,xgm';
set @v_text3 = '!!@@@#&^@%#$&^UILKFL:#()KN HÁGR:G"L DKG$çUITYj5j6y2[56yjsd';
set @v_text4 = 'HUYTE$%piÅ4u€fa£sdfj©fffa®dgasfŸdgt34q¥9utj;gØfdtkl49h7vme;a&9bj3;a]1kbjnha-8nhna=nu49q#ert e34f';
Set @v_count=1
Begin TRAN
While @v_count<2001
Begin
Insert into sp_ss.ssc_nchar values(
@v_count,
@v_text1,
'',
@v_text3+@v_text2,
null)
Insert into sp_ss.ssc_nchar_max values(
@v_count,
'',
null)
Set @v_count=@v_count +1
End
save tran A

While @v_count<4001
Begin
Insert into sp_ss.ssc_nchar values(
@v_count,
cast(floor(rand()*100000) as nchar(10))+@v_text2,
@v_text3+cast(floor(rand()*100000) as nchar(10)),
cast(floor(rand()*999999) as nchar(10)),
cast(floor(rand()*9999999999) as nchar(15)) + replicate(@v_text4,5))
Insert into sp_ss.ssc_nchar_max values(
@v_count,
@v_text3,
substring(convert(nvarchar(max),replicate(newid(),20))+replicate(@v_text4+@v_text1+@v_text2+@v_text3,15),1,3700))
Set @v_count=@v_count +1
End
Save Tran B 

While @v_count<6001
Begin
Update sp_ss.ssc_nchar set 
COL_NCHAR1=@v_text3,
COL_NCHAR2=@v_text1+cast(floor(rand()*88888) as nchar(10)),
COL_NCHAR3=cast(floor(rand()*888888) as nchar(10))+replicate(@v_text4,5),
COL_NCHAR4=cast(floor(rand()*8888888888) as nchar(15))+replicate(@v_text2+@v_text1,5)
where COL_NUMBER=@v_count
Update sp_ss.ssc_nchar_max set 
COL_NCHAR1=@v_text3,
COL_NCHAR2=convert(nchar,getdate(),120)+replicate(@v_text4,20) 
where COL_NUMBER=@v_count-4000
Set @v_count=@v_count +1
End
Rollback tran B

While @v_count<7001
Begin
Delete from sp_ss.ssc_nchar where COL_NUMBER < @v_count-6000
Delete from sp_ss.ssc_nchar_max where COL_NUMBER < @v_count-6000
Set @v_count=@v_count+1
End
Rollback tran A

Commit tran 
go
SET NOCOUNT OFF
