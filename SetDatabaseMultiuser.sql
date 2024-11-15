USE Master 
GO

declare @sql as varchar(20), @spid as int

select @spid = min(spid)  from master..sysprocesses  where dbid = db_id('AxDB')  and spid != @@spid    

while (@spid is not null) 
begin
    print 'Killing process ' + cast(@spid as varchar) + ' ...'
    set @sql = 'kill ' + cast(@spid as varchar)
    exec (@sql)

    select 
        @spid = min(spid)  
    from 
        master..sysprocesses  
    where 
        spid > 50 AND dbid = db_id('AxDB') 
        and spid != @@spid 
end 
print 'Killing Process completed...' 
GO

**--Alter user mode** 
ALTER DATABASE AxDB SET MULTI_USER; 
GO 
print 'Alter Database Process completed...'
