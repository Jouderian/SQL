--------------------------------------------------------------------------------
-- Descricao: Mostra a quantidade de admitidos e desligados por mes no ano atual
-- Versao: 1 (25/08/25) Jouderian:
--------------------------------------------------------------------------------
-- Observacao: o collate do banco tem que ser SQL_Latin1_General_CP1_CI_AI
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
  isNull(desligados.QTD, 0) as 'Desligados'
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