SET NOCOUNT ON
use sp_ss
go

delete from sp_ss.ssc_time

insert into sp_ss.ssc_time values(1, 
'00:00:00.0000000',
'00:00:00.0000000',
'00:00:00.0000000',
'00:00:00.0000000',
'00:00:00.0000000',
'00:00:00.0000000',
'00:00:00.0000000',
'00:00:00.0000000');
insert into sp_ss.ssc_time values(2, 
'23:59:59.9999999',
'23:59:59.9999999',
'23:59:59.9999999',
'23:59:59.9999999',
'23:59:59.9999999',
'23:59:59.9999999',
'23:59:59.9999999',
'23:59:59.9999999');
go

declare @i int
set @i=3
while @i<10001
begin 
insert into sp_ss.ssc_time values(@i,  
 DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh, @i, GETDATE())))),
 DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh, @i, GETDATE())))),
 DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh, @i, GETDATE())))),
 DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh, @i, GETDATE())))),
 DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh, @i, GETDATE())))),
 DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh, @i, GETDATE())))),
 DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh, @i, GETDATE())))),
 DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh, @i, GETDATE()))))
 );
set @i=@i+1
end
go

declare @j int
set @j=1111111
while @j<1112111
begin 
insert into sp_ss.ssc_time values(@j,
convert(varchar(10),@j%24)+':'+convert(varchar(10),@j%60)+':'+convert(varchar(10),@j%60)+'.'+convert(varchar(10),@j%9999999),
convert(varchar(10),@j%24)+':'+convert(varchar(10),@j%60)+':'+convert(varchar(10),@j%60)+'.'+convert(varchar(10),@j%9999999),
convert(varchar(10),@j%24)+':'+convert(varchar(10),@j%60)+':'+convert(varchar(10),@j%60)+'.'+convert(varchar(10),@j%9999999),
convert(varchar(10),@j%24)+':'+convert(varchar(10),@j%60)+':'+convert(varchar(10),@j%60)+'.'+convert(varchar(10),@j%9999999),
convert(varchar(10),@j%24)+':'+convert(varchar(10),@j%60)+':'+convert(varchar(10),@j%60)+'.'+convert(varchar(10),@j%9999999),
convert(varchar(10),@j%24)+':'+convert(varchar(10),@j%60)+':'+convert(varchar(10),@j%60)+'.'+convert(varchar(10),@j%9999999),
convert(varchar(10),@j%24)+':'+convert(varchar(10),@j%60)+':'+convert(varchar(10),@j%60)+'.'+convert(varchar(10),@j%9999999),
convert(varchar(10),@j%24)+':'+convert(varchar(10),@j%60)+':'+convert(varchar(10),@j%60)+'.'+convert(varchar(10),@j%9999999)
);
set @j=@j+1
end
go
SET NOCOUNT OFF
