SET NOCOUNT ON

use sp_ss
go
begin 
delete from sp_ss.ssc_date where COL_NUMBER<2500
end

SET NOCOUNT OFF
