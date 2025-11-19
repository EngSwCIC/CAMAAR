Feature: Atualizar base de dados com os dados do SIGAA
  Como Administrador
  Quero atualizar a base de dados já existente com os dados atuais do SIGAA
  A fim de corrigir a base de dados do sistema

  Scenario: Atualiza a base de dados com sucesso
    Given que o administrador está logado
    When clica em importar dados
    And adiciona o arquivo CSV válido
    Then aparece uma mensagem informando que os dados foram atualizados com sucesso
    And sou redirecionado para a página de cadastro de alunos

  Scenario: Falha ao atualizar a base de dados
    When clica em importar dados
    And adiciona um arquivo CSV inválido
    Then o sistema impede a atualização dos dados
    And exibe uma mensagem de erro informando que o arquivo não pode ser importado
