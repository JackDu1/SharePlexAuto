SET NOCOUNT ON
use sp_ss
go
begin 
delete from sp_ss.ssc_int where COL1<9500
end
go
SET NOCOUNT OFF
