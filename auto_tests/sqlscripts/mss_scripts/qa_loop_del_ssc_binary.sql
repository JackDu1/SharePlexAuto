SET NOCOUNT ON
use sp_ss
go
begin 
delete from sp_ss.ssc_binary where COL_NUMBER<950
delete from sp_ss.ssc_varbinary where COL1<950
end
go
SET NOCOUNT OFF
