# arquivo de especificação da issue "Cadastrar usuários do sistema" (Sprint 1)
@issue-100
Feature: Cadastrar usuários do sistema
  Como administrador
  Quero cadastrar participantes de turmas do SIGAA ao importar dados
  A fim de que possam acessar o sistema CAMAAR (ativação após definição de senha)

  Cenário: Cadastro de novos participantes (feliz)
    Dado que há usuários do SIGAA que ainda não existem na base
    Quando o administrador conclui a importação
    Então o sistema deve criar registros para esses usuários como pendentes de definição de senha

  Cenário: Usuários já cadastrados (triste)
    Dado que todos os usuários presentes nos arquivos já existem na base
    Quando o administrador conclui a importação
    Então o sistema não deve criar registros duplicados
