SET NOCOUNT ON
delete from sp_ss.ssc_varchar
declare @i int, @v_text1 varchar(max), @v_text2 varchar(max), @v_text3 varchar(max), @v_text4 varchar(max)
set @i=1
set @v_text1 = '34t5ugj;xcnmgiqt© 9§3u53u7-5ekgbb¥nhsfh-054µ6934-7KJFSDGB;NM'
set @v_text2 = ',bsfk095t6i3m,bß hmyÂutejgklfdklfdgkn6-yifl;hm¿vxcmgakg46095½86-0u8bknbn.z,xgm'
set @v_text3 = '&^@%#$&^UILKFL:#()KN HÁR:G"L DKG$çTYj5j6y2[56yjsd'
set @v_text4 = 'piÅufa£sdfj©fffa®dgasfdgt34q¥9utj;gØdxÎmgjtptkl49h7vme;a&9bj3;a]1kbjnha-8nhna=nu49q#ert e34f'
while @i<1001
begin
insert into sp_ss.ssc_varchar values (
@i,
replicate(newid(),-1),
'',
replicate(newid(),-1),
'',
newid(),
newid()
)
set @i=@i+1
end
while @i<2001
begin
insert into sp_ss.ssc_varchar values (
@i,
newid(),
left(replicate(newid(), 20),1000),
left(replicate(newid(),28),1001),
replicate(newid(),20),
replicate(newid(),100),
replicate(newid(),220)
)
set @i=@i+1
end
while @i<3001
begin
insert into sp_ss.ssc_varchar values (
@i,
left(replicate(newid(), 14),500),
right(replicate(newid(),28),1000),
left(replicate(newid(),28),1001),
right(replicate(newid(),112),4000),
left(replicate(convert(varchar(max),newid()),223),8000),
right(replicate(convert(varchar(max),newid()),223),8000)
)
set @i=@i+1
end
while @i<4001
begin
insert into sp_ss.ssc_varchar values (
@i,
replicate(rand()*9999999999,20),
left(replicate(rand()*9999999999,340),1000),
left(replicate(rand()*9999999999,340),1001),
replicate(rand()*9999999999,200),
replicate(rand()*9999999999,680),
left(replicate(convert(varchar(max),rand()*9999999999),680),8000)
)
set @i=@i+1
end
while @i<5001
begin
insert into sp_ss.ssc_varchar values (
@i,
replicate(convert(varchar(30),getDate(),100),10),
right(replicate(convert(varchar(30),getDate(),100),55),1000),
right(replicate(convert(varchar(30),getDate(),100),55),1001),
replicate(convert(varchar(30),getDate(),100),200),
replicate(convert(varchar(30),getDate(),100),300),
right(replicate(convert(varchar(max),convert(varchar(30),getDate(),100)),422),8000)
)
set @i=@i+1
end
while @i<6001
begin
insert into sp_ss.ssc_varchar values (
@i,
@v_text1+@v_text2+@v_text3+@v_text4,
left(replicate(@v_text1+@v_text2+@v_text3+@v_text4,4),1000),
right(replicate(@v_text1+@v_text2+@v_text3+@v_text4,4),1001),
replicate(@v_text1+@v_text2+@v_text3+@v_text4,10),
replicate(@v_text1+@v_text2+@v_text3+@v_text4,20),
left(replicate(@v_text1+@v_text2+@v_text3+@v_text4,28),8000)
)
set @i=@i+1
end
go
SET NOCOUNT OFF
