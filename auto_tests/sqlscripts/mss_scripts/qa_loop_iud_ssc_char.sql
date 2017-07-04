SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_char;
declare @i int = 0;
DECLARE @intFlag INT=0;
declare @v_text1 varchar(max),@v_text2 varchar(max),@v_text3 varchar(max),@v_text4 varchar(max)
set @v_text4 = 'piÅ4u€fa£sdfj©fffa®dgasfŸdgt34q¥9utj;gØfdxÎjmgjtptkl49h7vme;a&9bj3;a]1kbjnha-8nhna=nu49q#fag e34f';
set @v_text1 = '34t5ugj;xcnmgiqt© 9§3u53u7-5ekgbvcgb¥nhsfh-054µ6934-7KJFSDGB;NM';
set @v_text2 = ',bsfk095t6i3m,bßk hmyÂ3utejgklfdklfdgkn6-yifl;hm¿vxcmgakg46095½86-0u8bknbn.z,xgm';
set @v_text3 = '&^@%#$&^UILKFL:#()KN HÁGR:G"L DKG$çUITYj5j6y2[56yjsd';
while @i < 2000
begin
insert into sp_ss.ssc_char values(@i,
replicate(@v_text1,floor(rand()*1.9)),
replicate(@v_text1,floor(rand()*3.9)), 
replicate(@v_text1,floor(rand()*3.9)) + replicate(@v_text4,floor(rand()*3.9)), 
replicate(@v_text2,floor(rand()*3.9)) + replicate(@v_text1,floor(rand()*3.9)) + replicate(@v_text3,floor(rand()*3.9)), 
replicate(@v_text3,floor(rand()*3.9)) + @v_text4 + replicate(@v_text1,floor(rand()*3.9)));
set @i = @i + 1;
end;
WHILE (@intFlag <1000)
BEGIN
PRINT @intFlag
update sp_ss.ssc_char
set COL_CHAR1 = @v_text4,
COL_CHAR2 = NULL,
COL_CHAR3 = @v_text1 + @v_text2+@v_text4,
COL_CHAR4 = ' ',
COL_CHAR5 = @v_text3 + @v_text4
where COL_NUMBER = @intFlag;
SET @intFlag = @intFlag + 1;
END;
begin 
delete from sp_ss.ssc_char where COL1 between 333 and 1111;
end;
SET NOCOUNT OFF
