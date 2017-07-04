--USE sp_ss
--GO
--DROP LOGIN sp_ss
--GO

USE sp_ss    -- drop schema

-- first remove replicate 
--exec sp_replflush
--exec sp_removedbreplication @dbname=sp_ss
go

-- delete all tables in schema
declare @var_name varchar(1000)
declare @sql varchar(1000)
declare 
	d_user cursor for 
		select 'drop table ' + SCHEMA_NAME(SCHEMA_ID)+'.' +name from sys.objects 
		where type='u' and SCHEMA_NAME(schema_id) ='sp_ss'

	open d_user
	fetch next from d_user into @var_name 
	while @@FETCH_STATUS=0
	begin
	set @sql=@var_name
	exec(@sql)
	fetch next from d_user into @var_name
	end
	close d_user
	deallocate d_user
go
--drop schema
DROP SCHEMA sp_ss
GO

USE sp_ss
GO

DROP USER sp_ss
GO

USE master 
GO
DROP LOGIN sp_ss
GO

