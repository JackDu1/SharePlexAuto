SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_date

declare @i int
set @i=1
while @i<2001
begin 
insert into sp_ss.ssc_date values(@i,  
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,GETDATE()))),
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
CONVERT(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' -8:00',
DATEADD(yyyy,@i/150,DATEADD(m,@i/150,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh, @i, GETDATE()))))
);
set @i=@i+1
end

while @i<4001
begin 
insert into sp_ss.ssc_date values(@i,  
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,GETDATE()))),
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
CONVERT(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' +6:00',
DATEADD(yyyy,@i/150,DATEADD(m,@i/150,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh, @i, GETDATE()))))
);
set @i=@i+1
end

declare @u int
set @u=1
while @u<3000
begin 
update sp_ss.ssc_date set 
COL_DATE1=DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,GETDATE()))),
COL_DATE2=DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),
COL_DATE3=DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),
COL_DATE4=CONVERT(varchar(50),DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),121) + ' -3:00',
COL_DATE5=DATEADD(yyyy,@u/150,DATEADD(m,@u/150,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),
COL_DATE6=DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh, @u, GETDATE()))))
WHERE COL_NUMBER=@u
set @u=@u+1
end

declare @k int
set @k=1
while @k<600
begin 
delete from sp_ss.ssc_date where COL_NUMBER in (@k+500,4000-@k)
set @k=@k+1
end
go

SET NOCOUNT OFF
