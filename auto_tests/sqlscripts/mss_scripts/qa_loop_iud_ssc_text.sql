SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_text;
declare @i int = 0;
declare @v_text1 varchar(max),@v_text2 varchar(max),@v_text3 varchar(max),@v_text4 varchar(max)
set @v_text1 = '-34t5ugj;xcnmgiqt©-9§3u53u7-5ekgbvcgb¥nhsfh-054µ6934-7KJFSDGB;NM';
set @v_text2 = ',bsfk095t6i3m,bßkhmyÂ3utejgklfdklfdgkn6-yifl;hm¿vxcmgakg46095½86-0u8bknbn.z,xgm';
set @v_text3 = '&^@%#$&^UILKFL:#()KNHÁGR:G"LDKG$çUITYj5j6y2[56yjsd';
set @v_text4 = '€£¤ƒŠŽŒŠËùøöÿ';
while @i < 100
begin
insert into sp_ss.ssc_text values(@i,@v_text4, @v_text2, @v_text3, @v_text1);
set @i = @i + 1;
end;
DECLARE @intFlag INT=0;
declare @v_text1 varchar(max),@v_text2 varchar(max),@v_text3 varchar(max),@v_text4 varchar(max)
set @v_text4 = '0¥xµab¢cd€ef01ƒ2Â345ä678æad®fasl;ŒfsŠa‰d©hf;saÿdkj÷fwe¾4ut0i9ñuto[jfdg9';
set @v_text1 =(select BulkColumn from openrowset(bulk N'/spoqa/lob_files/clob_file_0.1m', single_clob) as text);
set @v_text2 =(select BulkColumn from openrowset(bulk N'/spoqa/lob_files/clob_file_1m', single_clob) as text);
set @v_text3 =(select BulkColumn from openrowset(bulk N'/spoqa/lob_files/clob_file_9m', single_clob) as text);
WHILE (@intFlag <20)
BEGIN
PRINT @intFlag
update sp_ss.ssc_text
set COL_TEXT1 = @v_text4,
COL_TEXT2 = NULL,
COL_TEXT3 = @v_text1 + @v_text2+@v_text4,
COL_TEXT4 = @v_text3 + @v_text4
where COL_NUMBER = @intFlag;
SET @intFlag = @intFlag + 1;
END;
commit TRAN;
begin 
delete from sp_ss.ssc_text where COL_NUMBER < 50
end
go
SET NOCOUNT OFF
