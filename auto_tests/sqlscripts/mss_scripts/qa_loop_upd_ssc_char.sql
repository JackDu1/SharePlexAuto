SET NOCOUNT ON
use sp_ss
go
DECLARE @intFlag INT=0;
declare @v_text1 varchar(max),@v_text2 varchar(max),@v_text3 varchar(max),@v_text4 varchar(max)
set @v_text4 = '0¥xµab¢cd€ef03761ƒ2Â345ä678æad®fasl;ŒfsŠa‰d©hf;saÿdkj÷fwe¾4ut0i9ñuto[jfdg9';
set @v_text1 = '34t5ugj;xcn568mgiqt© 9§3u53u7-5ekgbvcgb¥nhsfh-054µ6934-7KJFSDGB;NM';
set @v_text2 = ',bsfk0942565t6i3m,bßk hmyÂ3utejgklfdklfdgkn6-yifl;hm¿vxcmgakg46095½86-0u8bknbn.z,xgm';
set @v_text3 = 'wru6w&^@%#$&^UILKFL:#()KN HÁGR:G"L DKG$çUITYj5j6y2[56yjsd';
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
SET NOCOUNT OFF