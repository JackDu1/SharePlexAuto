SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_datetimeoffset

declare @i int
set @i=1
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

while @i<4001
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

declare @u int
set @u=1
while @u<3001
begin 
update sp_ss.ssc_datetimeoffset set
 COL0=convert(varchar(50),DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),121) + ' -12:00',
 COL1=convert(varchar(50),DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),121) + ' -11:00',
 COL2=convert(varchar(50),DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),121) + ' -8:00',
 COL3=convert(varchar(50),DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),121) + ' -5:00',
 COL4=convert(varchar(50),DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),121),
 COl5=convert(varchar(50),DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),121) + ' +3:00',
 COL6=convert(varchar(50),DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),121) + ' +8:00',
 COL7=convert(varchar(50),DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),121) + ' +14:00'
WHERE COL_NUMBER=@u
set @u=@u+1
end

declare @k int
set @k=1
while @k<600
begin 
delete from sp_ss.ssc_datetimeoffset where COL_NUMBER in (@k+500,4000-@k)
set @k=@k+1
end
go

SET NOCOUNT OFF
