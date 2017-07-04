use master
IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'ssc')
DROP LOGIN ssc
GO

CREATE LOGIN ssc WITH PASSWORD=N'ssc', DEFAULT_DATABASE=sp_ss, DEFAULT_LANGUAGE=us_english, CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO


EXEC master..sp_addsrvrolemember @loginame = N'ssc', @rolename = N'bulkadmin'
GO

use sp_ss
BEGIN
CREATE USER ssc FOR LOGIN ssc
ALTER USER ssc WITH DEFAULT_SCHEMA=sp_ssc
END
GO


