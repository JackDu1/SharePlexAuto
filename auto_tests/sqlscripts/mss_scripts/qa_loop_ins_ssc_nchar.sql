SET NOCOUNT ON
use sp_ss
go
Delete from sp_ss.ssc_nchar
Delete from sp_ss.ssc_nchar_max

Declare @v_count int
Declare @v_text1 varchar(max),@v_text2 varchar(max),@v_text3 varchar(max),@v_text4 varchar(max)
Set @v_count=1
set @v_text1 = '34t5ugj;xcnmgiqt© 9§3u53u7-5ekgbb¥nhsfh-054µ6934-7KJFSDGB;NM';
set @v_text2 = ',bsfk095t6i3m,bßk hmyÂ3utejgklfdklfdgkn6-yifl;hm¿vxcmgakg46095½86-0u8bknbn.z,xgm';
set @v_text3 = '&^@%#$&^UILKFL:#()KN HÁGR:G"L DKG$çUITYj5j6y2[56yjsd';
set @v_text4 = 'piÅ4u€fa£sdfj©fffa®dgasfŸdgt34q¥9utj;gØfdxÎjmgjtptkl49h7vme;a&9bj3;a]1kbjnha-8nhna=nu49q#ert e34f';
Begin TRAN;
While @v_count<3001
Begin
Insert into sp_ss.ssc_nchar values(
@v_count,
@v_text1+cast(floor(rand()*100000) as nchar(10)),
cast(floor(rand()*99999) as nchar(10))+@v_text2,
cast(floor(rand()*999999) as nchar(10))+@v_text3+@v_text2,
cast(floor(rand()*9999999999) as nchar(15))+replicate(@v_text4,10))
Insert into sp_ss.ssc_nchar_max values(
@v_count,
@v_text3,
substring(replicate(newid(),20)+replicate(@v_text4+@v_text1+@v_text2+@v_text3,15),1,3700))
Set @v_count=@v_count +1
End

while @v_count<4001
begin
Insert into sp_ss.ssc_nchar values(
@v_count,@v_text1,'',null,@v_text4)
Insert into sp_ss.ssc_nchar_max values(
@v_count,'',null)
Set @v_count=@v_count +1
end

while @v_count<6001
begin
Insert into sp_ss.ssc_nchar values(
@v_count,
@v_text1,
cast(floor(rand()*100000) as nchar(10)),
substring(replicate(@v_text4,15),1,1000),
Substring(Replicate(newid(),20)+replicate(@v_text2+@v_text3,20),1,2000))
Insert into sp_ss.ssc_nchar_max values(
@v_count,
newid(),
replicate(@v_text2+@v_text3+@v_text1+@v_text4,5) + convert(nchar,getdate(),120))
Set @v_count=@v_count +1
end
commit TRAN;
go

SET NOCOUNT OFF

