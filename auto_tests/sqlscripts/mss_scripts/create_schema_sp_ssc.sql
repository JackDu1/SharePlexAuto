USE sp_ss
GO

IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'sp_ssc')
DROP SCHEMA sp_ssc
GO


CREATE SCHEMA sp_ssc AUTHORIZATION  ssc
GO


