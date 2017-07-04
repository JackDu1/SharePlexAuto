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
while @i < 500
begin
insert into sp_ss.ssc_text values(@i,@v_text4, @v_text2, @v_text3, @v_text1);
set @i = @i + 1;
end;
SET NOCOUNT OFF
