SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_char
DECLARE @intFlag INT=0;
declare @v_text1 varchar(max),@v_text2 varchar(max),@v_text3 varchar(max),@v_text4 varchar(max);
set @v_text4 = 'adfsaƒdfsa€df©gh e3q5 ®y35£6y0¥xabcd§efØ01234þ56ß78ÿ9';
set @v_text1 = '34t5ugj;xcn568 mgiqt © 9§3u53u7-5ekgbvcgb¥nhsfh-054µ6934-7KJFSDGB;NM';
set @v_text2 = ',bsfk0942565t6i3m,bß k hmyÂ3utejgklfdklfdgkn6-yifl;hm¿vxcmgakg46095½86-0u8bknbn.z,xgm';
set @v_text3 = 'wru6w&^@% #$&^UIL KFL:#()KN HÁGR:G"L DKG$çUITYj5j6y2[56yjsd';
begin TRAN 
WHILE (@intFlag <500)
BEGIN
PRINT @intFlag
insert into sp_ss.ssc_char values(@intFlag, 
@v_text1, 
' ',
@v_text1 + @v_text2, 
NULL, 
@v_text2 +@v_text3 +@v_text4 +@v_text1);
SET @intFlag = @intFlag + 1;
END;
save tran A
WHILE (@intFlag <1000)
BEGIN
PRINT @intFlag
insert into sp_ss.ssc_char values(@intFlag, 
replicate(@v_text1,floor(rand()*1.9)),
replicate(@v_text1,floor(rand()*3.9)), 
replicate(@v_text1,floor(rand()*3.9)) + replicate(@v_text4,floor(rand()*3.9)), 
replicate(@v_text2,floor(rand()*3.9)) + replicate(@v_text1,floor(rand()*3.9)) + replicate(@v_text3,floor(rand()*3.9)), 
replicate(@v_text3,floor(rand()*3.9)) + @v_text4 + replicate(@v_text1,floor(rand()*3.9)));
SET @intFlag = @intFlag + 1;
END;
save tran B
WHILE (@intFlag <1500)
BEGIN
PRINT @intFlag
insert into sp_ss.ssc_char values(
@intFlag, 
replicate(@v_text1,floor(rand()*1.9)),
replicate(@v_text1,floor(rand()*3.9)), 
replicate(@v_text1,floor(rand()*3.9)) + replicate(@v_text4,floor(rand()*3.9)), 
replicate(@v_text2,floor(rand()*3.9)) + replicate(@v_text1,floor(rand()*3.9)) + replicate(@v_text3,floor(rand()*3.9)), 
replicate(@v_text3,floor(rand()*3.9)) + @v_text4 + replicate(@v_text1,floor(rand()*3.9)));
SET @intFlag = @intFlag + 1;
END;
rollback tran B;
WHILE (@intFlag <2000)
BEGIN
PRINT @intFlag
insert into sp_ss.ssc_char values(
@intFlag, 
replicate(@v_text1,floor(rand()*1.9)),
replicate(@v_text1,floor(rand()*3.9)), 
replicate(@v_text1,floor(rand()*3.9)) + replicate(@v_text4,floor(rand()*3.9)), 
replicate(@v_text2,floor(rand()*3.9)) + replicate(@v_text1,floor(rand()*3.9)) + replicate(@v_text3,floor(rand()*3.9)), 
replicate(@v_text3,floor(rand()*3.9)) + @v_text4 + replicate(@v_text1,floor(rand()*3.9)));
SET @intFlag = @intFlag + 1;
END;
rollback tran A;
commit tran;
SET NOCOUNT OFF