SET NOCOUNT ON
use sp_ss
go

delete from sp_ss.ssc_date

insert into sp_ss.ssc_date values(1,
'0001-01-01',
'1753-01-01 00:00:00.000',
'0001-01-01 00:00:00.0000000',
'0001-01-01 00:00:00.0000000 -12:00',
'1900-01-01 00:00:00',
'00:00:00.0000000'
);

insert into sp_ss.ssc_date values(2,
'9999-12-31',
'9999-12-31 23:59:59.997',
'9999-12-31 23:59:59.9999999',
'9999-12-31 23:59:59.9999999 +14:00',
'2079-06-06 23:59:29',
'23:59:59.9999999'
);

declare @i int
set @i=3
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


while @i<4001
begin 
insert into sp_ss.ssc_date values(@i,  
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,GETDATE()))),
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
CONVERT(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' +2:00',
DATEADD(yyyy,@i/150,DATEADD(m,@i/150,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh, @i, GETDATE()))))
);
set @i=@i+1
end

while @i<6001
begin 
insert into sp_ss.ssc_date values(@i,  
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,GETDATE()))),
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
CONVERT(varchar(50),DATEADD(yyyy,@i,DATEADD(m,@i,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),121) + ' +14:00',
DATEADD(yyyy,@i/150,DATEADD(m,@i/150,DATEADD(d,@i,DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh,@i,GETDATE()))))))),
DATEADD(ms,@i,DATEADD(ss,@i,DATEADD(mi,@i,DATEADD(hh, @i, GETDATE()))))
);
set @i=@i+1
end
go
SET NOCOUNT OFF
