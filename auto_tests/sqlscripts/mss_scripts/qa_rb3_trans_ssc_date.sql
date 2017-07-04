SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_date

declare @i int
set @i=1
begin tran
while @i<2001
begin 
insert into sp_ss.ssc_date values(@i,  
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,GETDATE()))),
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
CONVERT(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' -12:00',
DATEADD(yyyy,@i/150,DATEADD(m,@i/150,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh, @i, GETDATE()))))
);
set @i=@i+1
end
save tran A

while @i<4001
begin 
insert into sp_ss.ssc_date values(@i,  
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,GETDATE()))),
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
CONVERT(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' +12:00',
DATEADD(yyyy,@i/150,DATEADD(m,@i/150,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh, @i, GETDATE()))))
);
set @i=@i+1
end
save tran B

while @i<3001
begin
delete from sp_ss.ssc_date where COL_NUMBER=@i-1000
set @i=@i+1
end
rollback tran B

while @i<5001
begin 
insert into sp_ss.ssc_date values(@i,  
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,GETDATE()))),
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
CONVERT(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' +4:00',
DATEADD(yyyy,@i/150,DATEADD(m,@i/150,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh, @i, GETDATE()))))
);
set @i=@i+1
end
save tran C

while @i<6001
begin 
insert into sp_ss.ssc_date values(@i,  
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,GETDATE()))),
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
CONVERT(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' -1:00',
DATEADD(yyyy,@i/150,DATEADD(m,@i/150,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh, @i, GETDATE()))))
);
set @i=@i+1
end
rollback tran A
commit tran
go

SET NOCOUNT OFF
