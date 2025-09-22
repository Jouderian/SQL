--------------------------------------------------------------------------------
-- Descricao: Mostra a quantidade de funcionarios por situacao
-- Versao: 1 (27/08/25) Jouderian:
-- Versao: 2 (01/09/25) Jouderian: Incluido resumo dos funcionarios por situacao
--------------------------------------------------------------------------------

With admitidos as (
  Select
    Year(DATAADMISSAO) as 'ano',
    Month(DATAADMISSAO) as 'mes',
    Count(*) as 'qtd'
  From PFUNC
  Where DATAADMISSAO is Not Null
  Group By
    Year(DATAADMISSAO),
    Month(DATAADMISSAO)
),
desligados as (
  Select
    Year(DATADEMISSAO) as 'ano',
    Month(DATADEMISSAO) as 'mes',
    Count(*) AS 'qtd'
  From PFUNC
  Where DATADEMISSAO is Not Null
  Group By
    Year(DATADEMISSAO),
    Month(DATADEMISSAO)
)
Select
  Format(DateFromParts(Coalesce(admitidos.ANO, desligados.ANO), Coalesce(admitidos.MES, desligados.MES), 1), 'MMM/yy', 'pt-BR') AS 'Mes',
  isNull(admitidos.QTD, 0) as 'Admitidos',
  isNull(desligados.QTD, 0) as 'Demitidos'
From admitidos
full Outer Join desligados
  on admitidos.MES = desligados.MES
  and admitidos.ANO = desligados.ANO
Where
  Coalesce(admitidos.ANO, desligados.ANO) = Year(DateAdd(Day,-8,GetDate())) -- Considerando semana anterior para a virada do ano
  and Coalesce(admitidos.MES, desligados.MES) <= Month(DateAdd(Day,-8,GetDate())) -- Considerando semana anterior para a virada do ano
Order By
  Coalesce(admitidos.ANO, desligados.ANO),
  Coalesce(admitidos.MES, desligados.MES)


Select
  situacoes.DESCRICAO as 'Situacao',
  Count(1) as 'qtd'
From PFUNC as funcionarios
Join PCODSITUACAO as situacoes
  on situacoes.CODCLIENTE  = funcionarios.CODSITUACAO
Where funcionarios.CODSITUACAO not in (
  'D', /* Demitido */
  'I', /* Apos. por Incapacidade Permanente */
  'L', /* Licença s/venc */
  'V', /* Aviso Prévio */
  'Z'  /* Admissão prox.mês */
)
Group by situacoes.DESCRICAO
Order by Count(1) desc