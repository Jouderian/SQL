--------------------------------------------------------------------------------
-- Descricao: Mostra informacoes sobre o banco de dados do RM da TOTVS
-- Versao: 1 (18/07/25) Jouderian:
-- Observacao: o collate do banco tem que ser SQL_Latin1_General_CP1_CI_AI
--------------------------------------------------------------------------------

-- Mostra a descricao dos cammpos de uma tabela
Select *
From GDIC
Where TABELA like '%CHEFE%'
Order By
  TABELA,
  COLUNA 

-- Motra a descricao dos sistemas da TOTVS
Select
  CODSISTEMA,
  NOMESISTEMA,
  DESCRICAO
From GSISTEMA
Order By NOMESISTEMA 
