SET NOCOUNT ON
use sp_ss
go
begin 
delete from sp_ss.ssc_text where COL_NUMBER < 150
end
go
SET NOCOUNT OFF
