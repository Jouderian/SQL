/*******************************************************************************
Descricao: Relações funcionarios e suas situações
Versao: 1 (28/06/25) Jouderian Nobre: Criação do script
Versao: 2 (20/07/25) Jouderian Nobre: Melhoria para tratar os afastados e ajuste no uso do nome e nome social
versao: 3 (29/08/25) Jouderian Nobre: Melhoria no tratamento da ausencia de gestor
*******************************************************************************/

  Select Distinct
    Coalesce(afastamentos.TIPO, funcionarios.CODSITUACAO) as 'codSituacao',
    situacoes.DESCRICAO as 'Situacao',
    empresas.NOMEFANTASIA as 'Empresa',
    filiais.NOMEFANTASIA as 'Escritorio',
    Replace(Replace(departamentos.DESCRICAO, Char(13), ''), Char(10), '') as 'Departamento',
    pessoaChefes.NOME as 'nomeGestor',
    Case
      When pessoaChefes.EMAIL like '%@%'
      Then SubString(pessoaChefes.EMAIL,1,(CharIndex('@', pessoaChefes.EMAIL) - 1))
      Else Null
    End as 'Gestor',
    NullIf(departamentos.NROCENCUSTOCONT, '') as 'codCusto',
    centroCustos.NOME as 'centroCusto',
    funcionarios.CHAPA as 'matricula',
    Replace(Replace(cargos.NOME, Char(13), ''), Char(10), '') as 'Cargo',
    funcionarios.NOME as 'nomeCompleto',
    Coalesce(pessoas.APELIDO, pessoas.NOMESOCIAL, funcionarios.NOME) as 'nomeExibicao',
    Replace(Replace(pessoas.EMAIL, Char(13), ''), Char(10), '') as 'eMail',
    Case
      When pessoas.EMAIL like '%@%'
      Then SubString(pessoas.EMAIL,1,(CharIndex('@', pessoas.EMAIL) - 1))
      Else Null
    End as 'Usuario',
    pessoas.ESTADO as 'Estado',
    pessoas.CIDADE as 'Cidade',
    Cast(funcionarios.DATAADMISSAO as Date) as 'Admissao',
    Cast(afastamentos.INICIO as Date) as 'inicioAfastamento',
    Cast(afastamentos.FIM as Date) as 'fimAfastamento'
  From PFUNC as funcionarios
  Join PPESSOA as pessoas
    on pessoas.CODIGO = funcionarios.CODPESSOA
  Join GCOLIGADA as empresas
    on empresas.CODCOLIGADA = funcionarios.CODCOLIGADA
  Join GFILIAL as filiais
    on filiais.CODCOLIGADA = funcionarios.CODCOLIGADA
    and filiais.CODFILIAL = funcionarios.CODFILIAL
  Join PSECAO as departamentos
    on departamentos.CODCOLIGADA = funcionarios.CODCOLIGADA
    and departamentos.CODIGO = funcionarios.CODSECAO
  Join PFUNCAO as cargos
    on cargos.CODCOLIGADA = funcionarios.CODCOLIGADA
    and cargos.CODIGO = funcionarios.CODFUNCAO
  Left Join PCCUSTO as centroCustos
    on centroCustos.CODCOLIGADA = departamentos.CODCOLIGADA
    and centroCustos.CODCCUSTO = departamentos.NROCENCUSTOCONT
  Left Join (
    Select
      ausencias.CHAPA,
      ausencias.CODCOLIGADA,
      ausencias.TIPO,
      ausencias.DTINICIO as 'inicio',
      ausencias.DTFINAL as 'fim'
    From PFHSTAFT as ausencias
    union Select
      ferias.CHAPA,
      ferias.CODCOLIGADA,
      'F' as 'tipo',
      ferias.DATAINICIO as 'inicio',
      ferias.DATAFIM as 'fim'
    From PFUFERIASPER as ferias
    Where ferias.SITUACAOFERIAS in (
      'M', /* Marcadas */
      'P'  /* Paga */
    )
  ) as afastamentos
    on afastamentos.CHAPA = funcionarios.CHAPA
    and afastamentos.CODCOLIGADA = funcionarios.CODCOLIGADA
    and afastamentos.INICIO <= GetDate()
    and Cast(IsNull(afastamentos.FIM,GetDate()) as Date) >= Cast(GetDate() as Date)
  Join PCODSITUACAO as situacoes
    on situacoes.CODCLIENTE = Coalesce(afastamentos.TIPO, funcionarios.CODSITUACAO)
  Left Join PSUBSTCHEFE as chefes
    on chefes.CODCOLIGADA = funcionarios.CODCOLIGADA
    and chefes.CODSECAO = funcionarios.CODSECAO
    and Cast(chefes.DATAINICIO as Date) <= Cast(GetDate() as Date)
    and Cast(IsNull(chefes.DATAFIM,GetDate()) as Date) >= Cast(GetDate() as Date)
  Left Join PFUNC as dadosChefes
    on dadosChefes.CHAPA = chefes.CHAPASUBST
    and dadosChefes.CODCOLIGADA = chefes.CODCOLSUBST
    and dadosChefes.CODSITUACAO <> 'D' /* Demitido */
  Left Join PPESSOA as pessoaChefes
    on pessoaChefes.CODIGO = dadosChefes.CODPESSOA
  Where
    funcionarios.CODSITUACAO not in (
      'D', /* Demitido */
      'I', /* Apos. por Incapacidade Permanente */
      'L', /* Licença s/venc */
      'V', /* Aviso Prévio */
      'Z'  /* Admissão prox.mês */
    )
    and pessoas.EMAIL like '%@%'