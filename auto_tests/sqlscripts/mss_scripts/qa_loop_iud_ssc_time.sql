SET NOCOUNT ON
use sp_ss
go
delete from sp_ss.ssc_time

declare @i int
set @i=1
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

declare @u int
set @u=1
while @u<10001
begin 
update sp_ss.ssc_time set 
 COL0=DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh, @u, GETDATE())))),
 COL1=DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh, @u, GETDATE())))),
 COL2=DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh, @u, GETDATE())))),
 COL3=DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh, @u, GETDATE())))),
 COL4=DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh, @u, GETDATE())))),
 COL5=DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh, @u, GETDATE())))),
 COL6=DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh, @u, GETDATE())))),
 COL7=DATEADD(ms,@u,DATEADD(ss,@u,DATEADD(mi,@u,DATEADD(hh, @u, GETDATE()))))
WHERE COL_NUMBER=@u
set @u=@u+1
end

declare @k int
set @k=1
while @k<600
begin 
delete from sp_ss.ssc_time where COL_NUMBER in (@k+500,10000-@k,4000+@k)
set @k=@k+1
end
go

SET NOCOUNT OFF
