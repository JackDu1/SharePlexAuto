SET NOCOUNT ON
use sp_ss
Declare @v_count int
Declare @v_text1 varchar(max),@v_text2 varchar(max),@v_text3 varchar(max),@v_text4 varchar(max)
Set @v_count=4000
set @v_text1 = '34t5ugj;xcnmgiqt© 9§3u53u7-5ekgbb¥nhsfh-054µ6934-7KJFSDGB;NM';
set @v_text2 = ',bsfk095t6i3m,bßk hmyÂ3utejgklfdklfdgkn6-yifl;hm¿vxcmgakg46095½86-0u8bknbn.z,xgm';
set @v_text3 = '&^@%#$&^UILKFL:#()KN HÁGR:G"L DKG$çUITYj5j6y2[56yjsd';
set @v_text4 = 'piÅ4u€fa£sdfj©fffa®dgasfŸdgt34q¥9utj;gØfdxÎjmgjtptkl49h7vme;a&9bj3;a]1kbjnha-8nhna=nu49q#ert e34f';
Begin TRAN;

While @v_count>2000
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
where COL_NUMBER=@v_count
Set @v_count=@v_count -1
End

while @v_count>0
begin
Update sp_ss.ssc_nchar set 
COL_NCHAR1=@v_text2,
COL_NCHAR2=@v_text4,
COL_NCHAR3='',
COL_NCHAR4=null where COL_NUMBER=@v_count
Update sp_ss.ssc_nchar_max set 
COL_NCHAR1=@v_text4,
COL_NCHAR2=null where COL_NUMBER=@v_count
Set @v_count=@v_count -1
end

commit TRAN;
go

SET NOCOUNT OFF
