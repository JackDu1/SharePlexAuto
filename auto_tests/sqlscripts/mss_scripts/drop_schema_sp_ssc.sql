USE sp_ss
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'sp_ssc')
DROP SCHEMA sp_ssc
GO


