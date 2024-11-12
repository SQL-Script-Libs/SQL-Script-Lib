/***** Clean up *****/
--Disabling Change Data Capture on a table
USE [AxDBName];
GO
EXECUTE sys.sp_cdc_disable_table
@source_schema = N'dbo',
@source_name = N'[TableName]',
@capture_instance = N'dbo_[TableName]';
GO
--Disable Change Data Capture Feature on Database
USE [AxDBName]
GO
EXEC sys.sp_cdc_disable_db
GO
-- Truncate Table
Truncate table [TableName]
GO
