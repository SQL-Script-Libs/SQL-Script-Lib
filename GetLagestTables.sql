SELECT
tables.NAME AS TableName,
indexes.name as IndexName,
sum(partitions.rows) as NumberOfRows,
sum(allocation_units.total_pages) as TotalPages,
sum(allocation_units.used_pages) as UsedPages,
sum(allocation_units.data_pages) as DataPages,
(sum(allocation_units.total_pages) * 8) / 1024 as TotalSizeMB,
(sum(allocation_units.used_pages) * 8) / 1024 as UsedSizeMB,
(sum(allocation_units.data_pages) * 8) / 1024 as DataSizeMB
FROM
sys.tables
INNER JOIN     
sys.indexes ON tables.OBJECT_ID = indexes.object_id
INNER JOIN
sys.partitions ON indexes.object_id = partitions.OBJECT_ID AND indexes.index_id = partitions.index_id
INNER JOIN
sys.allocation_units ON partitions.partition_id = allocation_units.container_id
GROUP BY
tables.NAME, indexes.object_id, indexes.index_id, indexes.name
ORDER BY
TotalSizeMB DESC
