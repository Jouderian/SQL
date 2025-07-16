--------------------------------------------------------------------------------
-- Descricao: Usuários conectados no msSQL
-- Versao: 1 (17/12/13) Jouderian: Criação do script
--------------------------------------------------------------------------------

Select
  processos.spid,
  db_name(processos.dbid) as [Database],
  processos.login_time as Hora_Login,
  processos.status as Situacao,
  processos.Open_tran as Transacoes_Abertas,
  processos.loginame as Usuario,
  processos.Hostname as Estacao_Trabalho,
  processos.net_address as Endereco_Mac,
  processos.program_name as Aplicacao
From master..sysProcesses processos