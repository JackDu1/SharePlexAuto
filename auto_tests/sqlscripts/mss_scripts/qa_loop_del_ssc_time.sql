SET NOCOUNT ON

use sp_ss
go
begin 
delete from sp_ss.ssc_time where COL_NUMBER<5000
end

SET NOCOUNT OFF
