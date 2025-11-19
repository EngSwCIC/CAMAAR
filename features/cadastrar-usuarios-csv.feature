Feature: Cadastro de usuários por um administrador
  Como Administrador
  Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuários novos para o sistema
  A fim de que eles acessem o sistema CAMAAR

  Scenario: Cadastro de alunos efetuado com sucesso
    Given que um administrador acessa o sistema
    When os dados dos usuários são importados por meio de um arquivo csv
    Then sou redirecionado a uma nova página para cadastrar os alunos
    And ao clicar no botão de cadastro, os alunos são cadastrados
    And uma mensagem de cadastro de alunos efetuado com sucesso é exibida

  Scenario: Tentar cadastrar alunos com dados inválidos
    Given que estou logado como administrador
    When faço upload de um arquivo com dados errados
    Then o sistema exibe uma mensagem de erro
    And ao clicar no botão não acontece nada
