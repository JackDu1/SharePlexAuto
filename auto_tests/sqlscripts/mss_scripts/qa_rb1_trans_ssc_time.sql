SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_time

declare @i int
set @i=1
begin tran
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
save tran A
while @i<20001
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
rollback tran A
commit tran
go

SET NOCOUNT OFF
