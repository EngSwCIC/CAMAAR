Feature: Edição e delegação de templates
  Como Administrador
  Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
  A fim de organizar os templates existentes

  Scenario: Editar ou deletar um template com sucesso
    Given que o administrador está na página do template
    When ele edita ou deleta os campos do template
    Then o sistema deve editar ou deletar o template
    And exibir uma mensagem de confirmação

  Scenario: Falha ao editar um template com dados inválidos
    Given que o administrador está na página do template
    When ele tenta editar o template inserindo dados inválidos
    Then o sistema não aceita os dados inválidos
    And exibe uma mensagem de erro
