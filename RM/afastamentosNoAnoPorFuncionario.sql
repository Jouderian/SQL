/*******************************************************************************
Descricao: Relações afastamentos no ano por funcionario
Versao: 1 (01/12/25) Jouderian Nobre: Criação do script
*******************************************************************************/

Select
  afastamentos.criadoEm,
  afastamentos.criadoPor,
  afastamentos.modificadoEm,
  afastamentos.modificadoPor,
  situacoes.DESCRICAO as 'tipoAfastamento',
  Cast(afastamentos.inicio as Date) as 'Inicio',
  Cast(afastamentos.fim as Date) as 'Fim'
From (
  Select
    ausencias.CHAPA,
    ausencias.TIPO,
    ausencias.DTINICIO as 'inicio',
    ausencias.DTFINAL as 'fim',
    ausencias.RECCREATEDBY as 'criadoPor',
    ausencias.RECCREATEDON as 'criadoEm',
    ausencias.RECMODIFIEDBY as 'modificadoPor',
    ausencias.RECMODIFIEDON as 'modificadoEm'
  From PFHSTAFT as ausencias
  Union Select
    ferias.CHAPA,
    'F' as 'tipo',
    ferias.DATAINICIO as 'inicio',
    ferias.DATAFIM as 'fim',
    ferias.RECCREATEDBY as 'criadoPor',
    ferias.RECCREATEDON as 'criadoEm',
    ferias.RECMODIFIEDBY as 'modificadoPor',
    ferias.RECMODIFIEDON as 'modificadoEm'
  From PFUFERIASPER as ferias
) as afastamentos
Left Join PCODSITUACAO as situacoes
  on situacoes.CODCLIENTE = afastamentos.TIPO
Where
  Year(afastamentos.INICIO) >= Year(GetDate())
  and afastamentos.CHAPA = '2000102873'
Order By
  afastamentos.criadoEm,
  afastamentos.modificadoEm