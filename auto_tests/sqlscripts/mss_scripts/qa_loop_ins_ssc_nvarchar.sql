SET NOCOUNT ON
use sp_ss
go
Delete from sp_ss.ssc_nvarchar
Declare @v_count int
Declare @v_text1 nvarchar(max),@v_text2 nvarchar(max),@v_text3 nvarchar(max),@v_text4 nvarchar(max)
Set @v_count=1
set @v_text1 = '34t5ugj;xcnmgiqt© 9§3u53u7-5ekgbb¥nhsfh-054µ6934-7KJFSDGB;NM';
set @v_text2 = ',bsfk095t6i3m,bßk hmyÂ3utejgklfdklfdgkn6-yifl;hm¿vxcmgakg46095½86-0u8bknbn.z,xgm';
set @v_text3 = '&^@%#$&^UILKFL:#()KN HÁGR:G"L DKG$çUITYj5j6y2[56yjsd';
set @v_text4 = 'piÅ4u€fa£sdfj©fffa®dgasfŸdgt34q¥9utj;gØfdxÎjmgjtptkl49h7vme;a&9bj3;a]1kbjnha-8nhna=nu49q#ert e34f';
Begin TRAN;
While @v_count<3001
Begin
Insert into sp_ss.ssc_nvarchar values(
@v_count,
@v_text1+cast(floor(rand()*100000) as nchar(10)),
cast(floor(rand()*99999) as nchar(10))+@v_text2+@v_text4,
cast(floor(rand()*999999) as nchar(10))+@v_text3+replicate(@v_text2,10),
cast(floor(rand()*9999999999) as nchar(15))+replicate(@v_text4,10),
cast(floor(rand()*9999999999999) as nchar(20))+replicate(@v_text1+@v_text4,10),
cast(floor(rand()*999999999999999) as nchar(20))+replicate(@v_text3+@v_text2+@v_text1,15))
Set @v_count=@v_count +1 
End

while @v_count<4001
begin
Insert into sp_ss.ssc_nvarchar values(
@v_count,@v_text1,'',null,@v_text4,null,'')
Set @v_count=@v_count +1 
end

while @v_count<6001
begin
Insert into sp_ss.ssc_nvarchar values(
@v_count,
@v_text1,
substring(cast(floor(rand()*100000) as nchar(10))+replicate(@v_text4,15),1,1000),
substring(replicate(newid(),10)+replicate(@v_text4+@v_text1,15),1,2000),
Substring(Replicate(newid(),20)+replicate(@v_text2+@v_text3,20),1,2001),
substring(replicate(@v_text1+@v_text2+@v_text3,18)+replicate(newid(),10),1,4000),
replicate(@v_text1+@v_text2+@v_text3+@v_text4+convert(nchar,getdate(),120),15))
Set @v_count=@v_count +1 
end
commit TRAN;
SET NOCOUNT OFF
