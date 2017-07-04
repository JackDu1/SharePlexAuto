SET NOCOUNT ON

use sp_ss
go
begin 
delete from sp_ss.ssc_datetime2 where COL_NUMBER<3000
end

SET NOCOUNT OFF
