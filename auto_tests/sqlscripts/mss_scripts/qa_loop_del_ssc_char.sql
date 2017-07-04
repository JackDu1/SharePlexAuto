SET NOCOUNT ON
use sp_ss
go
begin 
delete from sp_ss.ssc_char where COL_NUMBER between 444 and 1111 ;
end
go
SET NOCOUNT OFF
