SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_datetime2

declare @i int
set @i=1
while @i<2001
begin 
insert into sp_ss.ssc_datetime2 values(@i,  
 DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
 DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
 DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
 DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
 DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
 DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
 DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
 DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE())))))))
 );
set @i=@i+1
end

while @i<4001
begin 
insert into sp_ss.ssc_datetime2 values(@i,  
 DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
 DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
 DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
 DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
 DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
 DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
 DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
 DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE())))))))
 );
set @i=@i+1
end

declare @u int
set @u=1
while @u<1001
begin 
update sp_ss.ssc_datetime2 set 
 COL0=DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),
 COL1=DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),
 COL2=DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),
 COL3=DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),
 COL4=DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),
 COL5=DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),
 COL6=DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE()))))))),
 COL7=DATEADD(yyyy,@u,DATEADD(m,@u,DATEADD(d,@u,DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh,@u,GETDATE())))))))
WHERE COL_NUMBER=@u
set @u=@u+1
end

declare @k int
set @k=1
while @k<600
begin 
delete from sp_ss.ssc_datetime2 where COL_NUMBER in (@k+500,4000-@k)
set @k=@k+1
end
go

SET NOCOUNT OFF
