--------------------------------------------------------------------------------
-- Descricao: Coleta de informacoes do servidor msSQL Server e suas bases e usuarios
-- Versao: 1 (09/09/23) Jouderian:
-- Versao: 2 (16/07/25) Jouderian: Melhoria na coleta de informacoes
--------------------------------------------------------------------------------

-- Sobre o msSQL instaldo
SELECT DISTINCT
	SERVERPROPERTY('MachineName') AS machineName,
	SubString(@@version,1,25) AS productName,
	SERVERPROPERTY('productversion') AS productVersion,
	SERVERPROPERTY('productlevel') AS productLevel,
	SERVERPROPERTY('edition') AS Edition,
	SERVERPROPERTY('IsClustered') AS isClustered,
	create_date AS installationDate
FROM sys.server_principals
WHERE default_database_name = 'master'


-- Sobre o hardware do servidor
SELECT
  @@SERVERNAME AS MachineName,
  SUBSTRING(@@VERSION,1,25) AS ProductName,
  socket_count AS Sockets,
  cores_per_socket AS CoresPerSocket,
  physical_memory_kb / 1024 AS TotalMemoryMB,
  virtual_memory_committed_kb / 1024 AS UsedMemoryMB
FROM sys.dm_os_sys_info


-- Sobre os banco de dados SQL
SELECT
  bases.name AS dbName,
  bases.database_id AS dbID,
  bases.create_date AS creationDate,
  bases.state_desc AS status,
  bases.compatibility_level AS compatibilityLevel
FROM sys.databases bases
LEFT JOIN sys.master_files mf
  ON bases.database_id = mf.database_id
  AND mf.file_id = 1
ORDER BY bases.name

-- Sobre os usuario SQL
-- Execute esta consulta apenas para instancias licenciadas de Server + CAL!!!
SELECT 
  servers.default_database_name AS DbName,
  servers.name AS Login,
  servers.type_desc AS Type,
  servers.create_date AS CreateDate,
  servers.modify_date AS ModifyDate,
  servers.is_disabled AS IsDisabled,
  logins.hasaccess AS HasAccess,
  logins.sysadmin AS IsSysAdmin
FROM sys.server_principals servers
LEFT JOIN syslogins logins
  ON servers.name = logins.name
WHERE servers.type NOT IN ('R', 'C')
ORDER BY servers.name

-- Tempo de atividade do servidor
SELECT
  sqlserver_start_time AS SqlServerStartTime
FROM sys.dm_os_sys_info