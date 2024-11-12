/***** Enable CDC *****/
--The following script will enable CDC in AdventureWorks database.
USE [AxDBName]
GO
EXEC sys.sp_cdc_enable_db
GO
--Following script will enable CDC on dbo.TestTable table.
USE [AxDBName]
GO
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'[TableName]',
@role_name = NULL
GO
