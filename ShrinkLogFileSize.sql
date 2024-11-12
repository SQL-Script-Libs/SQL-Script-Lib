USE AxDB;   
GO   

-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE AxDB 
SET RECOVERY SIMPLE;   
GO   

-- Shrink the truncated log file to 1 MB.   
DBCC SHRINKFILE ('[LogFileName]', 1);   
GO   

-- Reset the database recovery model.   
ALTER DATABASE AxDB
SET RECOVERY FULL;
GO  
