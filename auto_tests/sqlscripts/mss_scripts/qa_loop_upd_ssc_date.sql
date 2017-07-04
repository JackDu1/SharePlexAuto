SET NOCOUNT ON
use sp_ss
go

declare @i int
set @i=1
while @i<3000
begin 
update sp_ss.ssc_date set 
COL_DATE1=DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,GETDATE()))),
COL_DATE2=DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
COL_DATE3=DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
COL_DATE4=CONVERT(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' -10:00',
COL_DATE5=DATEADD(yyyy,@i/150,DATEADD(m,@i/150,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
COL_DATE6=DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh, @i, GETDATE()))))
WHERE COL_NUMBER=@i
set @i=@i+1
end
go

SET NOCOUNT OFF
