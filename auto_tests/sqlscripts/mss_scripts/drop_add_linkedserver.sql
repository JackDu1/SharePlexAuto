/****** Object:  LinkedServer [OPXQW04]    Script Date: 07/12/2016 14:57:11 ******/
SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'OPXQW04'
go

IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'OPXQW04')
EXEC master.dbo.sp_dropserver @server=N'OPXQW04', @droplogins='droplogins'
GO

SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'OPXQW04'
go


/****** Object:  LinkedServer [OPXQW04]    Script Date: 07/12/2016 14:57:11 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'OPXQW04', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'OPXQW04',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'OPXQW04',@useself=N'True',@locallogin=N'sa',@rmtuser=NULL,@rmtpassword=NULL

GO

EXEC master.dbo.sp_serveroption @server=N'OPXQW04', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'OPXQW04', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'OPXQW04', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'OPXQW04', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'OPXQW04', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'OPXQW04', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'OPXQW04', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'OPXQW04', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'OPXQW04', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'OPXQW04', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'OPXQW04', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'OPXQW04', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'OPXQW04', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'OPXQW04'
go

