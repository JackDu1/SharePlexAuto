SET NOCOUNT ON
use sp_ss
go
begin 
delete from sp_ss.ssc_nchar where COL_NUMBER<2000
delete from sp_ss.ssc_nchar_max where COL_NUMBER > 4000
end
go
SET NOCOUNT OFF
