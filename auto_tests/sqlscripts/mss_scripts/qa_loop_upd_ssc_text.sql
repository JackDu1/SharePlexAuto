SET NOCOUNT ON
use sp_ss
go
DECLARE @intFlag INT=0;
declare @v_text1 varchar(max),@v_text2 varchar(max),@v_text3 varchar(max),@v_text4 varchar(max)
set @v_text4 = '0¥xµab¢cd€ef01ƒ2Â345ä678æad®fasl;ŒfsŠa‰d©hf;saÿdkj÷fwe¾4ut0i9ñuto[jfdg9';
begin TRAN ;
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
SET NOCOUNT OFF
