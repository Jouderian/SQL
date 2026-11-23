--------------------------------------------------------------------------------
-- Descricao: Usuários conectados no msSQL
--------------------------------------------------------------------------------

Select
  login_name,
  host_name,
  program_name
From sys.dm_exec_sessions
Where
  database_id = DB_ID('DMD')
  and is_user_process = 1
  and session_id <> @@SPID