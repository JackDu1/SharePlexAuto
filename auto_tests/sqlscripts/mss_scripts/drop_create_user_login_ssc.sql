USE sp_ss

IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'ssc')
DROP USER ssc
GO

IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'ssc')
DROP LOGIN ssc
GO

CREATE LOGIN ssc WITH PASSWORD=N'ssc', DEFAULT_DATABASE=sp_ss, DEFAULT_LANGUAGE=us_english, CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

CREATE USER ssc FOR LOGIN ssc
ALTER USER ssc WITH DEFAULT_SCHEMA=sp_ssc
GO

exec sp_addrolemember db_owner,ssc;

