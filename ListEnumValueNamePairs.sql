select t1.NAME, t2.ENUMID, t2.ENUMVALUE, t2.NAME EnumValueName from ENUMIDTABLE t1 
inner join ENUMVALUETABLE t2 on t1.ID = t2.ENUMID 
where t1.NAME = '[EnumName]'
