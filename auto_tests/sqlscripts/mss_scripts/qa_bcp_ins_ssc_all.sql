SET NOCOUNT ON
use sp_ss
go
Delete from sp_ss.ssc_number_all
Delete from sp_ss.ssc_char_all
Delete from sp_ss.ssc_nchar_all
Delete from sp_ss.ssc_date_all

bulk insert sp_ss.ssc_number_all from '/qa/splex/common/load/bcp/ssc_number.bcp' with (FIELDTERMINATOR = ',', ROWTERMINATOR ='\n',Errorfile='/qa/splex/common/load/bcp/ssc_number.bad');

bulk insert sp_ss.ssc_char_all from '/qa/splex/common/load/bcp/ssc_char.bcp' with (FIELDTERMINATOR = '    z', ROWTERMINATOR ='\n',Errorfile='/qa/splex/common/load/bcp/ssc_char.bad'); 

--exec master..xp_cmdshell 'bcp sp_ss.sp_ss.ssc_char_all format nul -w -f D:/qa/splex/common/load/bcp/ssc_char.fat  -T -t\0\0\0\0z -r\n' 

--exec master..xp_cmdshell 'bcp sp_ss.sp_ss.ssc_char_all in D:/qa/splex/common/load/bcp/ssc_char1.bcp -f D:/qa/splex/common/load/bcp/ssc_char.fat  -T' 

--bulk insert sp_ss.ssc_char_all from 'D:/qa/splex/common/load/bcp/ssc_char1.bcp' with (formatfile = 'D:/qa/splex/common/load/bcp/ssc_char.fat',errorfile='D:/qa/splex/common/load/bcp/errorlog1.txt');

bulk insert sp_ss.ssc_nchar_all from '/qa/splex/common/load/bcp/ssc_nchar.bcp' with (FIELDTERMINATOR = '    z', ROWTERMINATOR ='\n',Errorfile='/qa/splex/common/load/bcp/ssc_nchar.bad');

bulk insert sp_ss.ssc_date_all from '/qa/splex/common/load/bcp/ssc_date.bcp' with (FIELDTERMINATOR = ',', ROWTERMINATOR ='\n',Errorfile='/qa/splex/common/load/bcp/ssc_date.bad');
go
SET NOCOUNT OFF
