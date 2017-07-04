SET NOCOUNT ON

use sp_ss
go
begin 
delete from sp_ss.ssc_datetimeoffset where COL_NUMBER<2000
end

SET NOCOUNT OFF
