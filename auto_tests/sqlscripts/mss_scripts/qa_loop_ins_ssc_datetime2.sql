SET NOCOUNT ON
use sp_ss
go

delete from sp_ss.ssc_datetime2

insert into sp_ss.ssc_datetime2 values(1, 
'0001-01-01 00:00:00.0000000',
'0001-01-01 00:00:00.0000000',
'0001-01-01 00:00:00.0000000',
'0001-01-01 00:00:00.0000000',
'0001-01-01 00:00:00.0000000',
'0001-01-01 00:00:00.0000000',
'0001-01-01 00:00:00.0000000',
'0001-01-01 00:00:00.0000000'
);

insert into sp_ss.ssc_datetime2 values(2, 
'9999-12-31 23:59:59.9999999',
'9999-12-31 23:59:59.9999999',
'9999-12-31 23:59:59.9999999',
'9999-12-31 23:59:59.9999999',
'9999-12-31 23:59:59.9999999',
'9999-12-31 23:59:59.9999999',
'9999-12-31 23:59:59.9999999',
'9999-12-31 23:59:59.9999999'
);

declare @i int
set @i=3
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
go

SET NOCOUNT OFF
