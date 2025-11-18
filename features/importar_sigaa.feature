# arquivo de especificação da issue "Importar dados do SIGAA" (Sprint 1)
@issue-98
Feature: Importar dados do SIGAA
  Como administrador
  Quero importar dados de turmas, matérias e participantes do SIGAA (apenas os que não existem)
  A fim de alimentar a base de dados do sistema

  Cenário: Importação com dados novos (feliz)
    Dado que o administrador seleciona os arquivos do SIGAA
    Quando realiza a importação
    Então o sistema deve incluir apenas registros que não existem na base

  Cenário: Dados já existentes (triste)
    Dado que todos os registros dos arquivos já existem na base
    Quando realiza a importação
    Então o sistema não deve criar novos registros
