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
convert(varchar(10),@i%24)+':'+convert(varchar(10),@i%60)+':'+convert(varchar(10),@i%60)+'.'+convert(varchar(10),@i%9999999),
convert(varchar(10),@i%24)+':'+convert(varchar(10),@i%60)+':'+convert(varchar(10),@i%60)+'.'+convert(varchar(10),@i%9999999),
convert(varchar(10),@i%24)+':'+convert(varchar(10),@i%60)+':'+convert(varchar(10),@i%60)+'.'+convert(varchar(10),@i%9999999),
convert(varchar(10),@i%24)+':'+convert(varchar(10),@i%60)+':'+convert(varchar(10),@i%60)+'.'+convert(varchar(10),@i%9999999),
convert(varchar(10),@i%24)+':'+convert(varchar(10),@i%60)+':'+convert(varchar(10),@i%60)+'.'+convert(varchar(10),@i%9999999),
convert(varchar(10),@i%24)+':'+convert(varchar(10),@i%60)+':'+convert(varchar(10),@i%60)+'.'+convert(varchar(10),@i%9999999),
convert(varchar(10),@i%24)+':'+convert(varchar(10),@i%60)+':'+convert(varchar(10),@i%60)+'.'+convert(varchar(10),@i%9999999),
convert(varchar(10),@i%24)+':'+convert(varchar(10),@i%60)+':'+convert(varchar(10),@i%60)+'.'+convert(varchar(10),@i%9999999)
);
set @i=@i+1
end
save tran B

while @i<30001
begin
delete from sp_ss.ssc_time where COL_NUMBER=@i-10000
set @i=@i+1
end
rollback tran B

while @i<50001
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
save tran C

while @i<60001
begin 
insert into sp_ss.ssc_time values(@i,
convert(varchar(10),@i%24)+':'+convert(varchar(10),@i%60)+':'+convert(varchar(10),@i%60)+'.'+convert(varchar(10),@i%9999999),
convert(varchar(10),@i%24)+':'+convert(varchar(10),@i%60)+':'+convert(varchar(10),@i%60)+'.'+convert(varchar(10),@i%9999999),
convert(varchar(10),@i%24)+':'+convert(varchar(10),@i%60)+':'+convert(varchar(10),@i%60)+'.'+convert(varchar(10),@i%9999999),
convert(varchar(10),@i%24)+':'+convert(varchar(10),@i%60)+':'+convert(varchar(10),@i%60)+'.'+convert(varchar(10),@i%9999999),
convert(varchar(10),@i%24)+':'+convert(varchar(10),@i%60)+':'+convert(varchar(10),@i%60)+'.'+convert(varchar(10),@i%9999999),
convert(varchar(10),@i%24)+':'+convert(varchar(10),@i%60)+':'+convert(varchar(10),@i%60)+'.'+convert(varchar(10),@i%9999999),
convert(varchar(10),@i%24)+':'+convert(varchar(10),@i%60)+':'+convert(varchar(10),@i%60)+'.'+convert(varchar(10),@i%9999999),
convert(varchar(10),@i%24)+':'+convert(varchar(10),@i%60)+':'+convert(varchar(10),@i%60)+'.'+convert(varchar(10),@i%9999999)
);
set @i=@i+1
end
rollback tran A
commit tran
go

SET NOCOUNT OFF
