--------------------------------------------------------------------------------
-- Descricao: Mostra a quantidade de funcionarios por situacao
-- Versao: 1 (27/08/25) Jouderian:
--------------------------------------------------------------------------------

Select
  situacoes.DESCRICAO as 'Situacao',
  Count(*) as 'qtd'
From PFUNC as funcionarios
Join PCODSITUACAO as situacoes
  on situacoes.CODCLIENTE = funcionarios.CODSITUACAO
Where funcionarios.CODSITUACAO not in (
  'D', /* Demitido */
  'I', /* Apos. por Incapacidade Permanente */
  'L', /* Licença s/venc */
  'V', /* Aviso Prévio */
  'Z'  /* Admissão prox.mês */
)
Group by situacoes.DESCRICAO
Order by Count(*) desc