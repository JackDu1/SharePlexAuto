SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_datetimeoffset

declare @i int
set @i=1
begin tran
while @i<2001
begin 
insert into sp_ss.ssc_datetimeoffset values(@i,
 convert(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' -12:00',
 convert(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' -1:00',
 convert(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' -8:00',
 convert(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' -11:00',
 convert(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' -7:00',
 convert(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' +9:00',
 convert(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' +8:00',
 convert(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' +14:00'
);
set @i=@i+1
end
save tran A

while @i<4001
begin 
insert into sp_ss.ssc_datetimeoffset values(@i,
 convert(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' -6:00',
 convert(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' -5:00',
 convert(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' -4:00',
 convert(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' -3:00',
 convert(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' -2:00',
 convert(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' -1:00',
 convert(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121),
 convert(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + '  +1:00'
);
set @i=@i+1
end
rollback tran A
commit tran
go

SET NOCOUNT OFF
