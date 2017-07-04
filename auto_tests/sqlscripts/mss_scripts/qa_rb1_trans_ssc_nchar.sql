SET NOCOUNT ON
use sp_ss
go
Delete from sp_ss.ssc_nchar
Delete from sp_ss.ssc_nchar_max
Declare @v_count int
Declare @v_text1 varchar(max),@v_text2 varchar(max),@v_text3 varchar(max),@v_text4 varchar(max)
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

While @v_count<3001
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
Rollback tran A 
Commit tran
go
SET NOCOUNT OFF
