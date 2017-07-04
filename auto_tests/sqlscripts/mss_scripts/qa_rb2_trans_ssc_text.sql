SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_text
DECLARE @intFlag INT=0;
declare @v_text1 varchar(max),@v_text2 varchar(max),@v_text3 varchar(max),@v_text4 varchar(max);
set @v_text4 = 'adfsa?dfsa?df?ghe3q5?y35?6y0?xabcd¡ì?01234?56?78?9';
set @v_text1 =(select BulkColumn from openrowset(bulk N'/spoqa/lob_files/clob_file_0.2m', single_clob) as text);
set @v_text2 =(select BulkColumn from openrowset(bulk N'/spoqa/lob_files/clob_file_1m', single_clob) as text);
set @v_text3 =(select BulkColumn from openrowset(bulk N'/spoqa/lob_files/clob_file_0.5m', single_clob) as text);
begin TRAN 
WHILE (@intFlag <50)
BEGIN
PRINT @intFlag
insert into sp_ss.ssc_text values(@intFlag, 
@v_text1, 
@v_text1 + @v_text2, 
NULL, 
@v_text2 +@v_text3 +@v_text4 +@v_text1);
SET @intFlag = @intFlag + 1;
END;
save TRAN A;
WHILE (@intFlag <100)
BEGIN
PRINT @intFlag
insert into sp_ss.ssc_text values(@intFlag, 
@v_text1, 
@v_text2 + @v_text3, 
@v_text2 + @v_text1 + @v_text3, 
@v_text3 +@v_text4 +@v_text1);
SET @intFlag = @intFlag + 1;
END;
save tran B
WHILE (@intFlag <150)
BEGIN
PRINT @intFlag
insert into sp_ss.ssc_text values(@intFlag, 
@v_text1, 
@v_text1 + @v_text4, 
@v_text1 + @v_text1 + @v_text3, 
@v_text3 +@v_text4 +@v_text1);
SET @intFlag = @intFlag + 1;
END;
rollback tran B
commit tran;
SET NOCOUNT OFF
