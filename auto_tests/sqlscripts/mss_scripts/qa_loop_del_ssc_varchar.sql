SET NOCOUNT ON
use sp_ss
go
begin 
delete from sp_ss.ssc_varchar where COL_NUMBER<5000
end
go
SET NOCOUNT OFF
