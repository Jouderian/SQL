--------------------------------------------------------------------------------
-- Descricao: Registros por tabela
--------------------------------------------------------------------------------

SELECT
  OBJECT_NAME(object_id) AS Tabela,
  SUM(row_count) AS Linhas
FROM sys.dm_db_partition_stats
WHERE
  index_id IN (0,1)
  AND OBJECTPROPERTY(object_id,'IsUserTable') = 1
GROUP BY object_id HAVING SUM(row_count) > 0
ORDER BY Linhas DESC;