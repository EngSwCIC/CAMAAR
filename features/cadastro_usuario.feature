Feature: Cadastro de Usuário

  Como visitante,
  Quero conseguir criar uma conta para mim mesmo
  Para que eu consiga ter acesso ao sistema

  Scenario: Cadastro realizado com sucesso
    Given que o usuário está na tela de cadastro
    When ele informa nome válido
    And informa email válido
    And informa uma senha válida
    Then o sistema deve cadastrar o usuário com sucesso

  Scenario: Cadastro com email já existente
    Given que o usuário está na tela de cadastro
    When ele informa um email já cadastrado
    And informa uma senha válida
    Then o sistema deve exibir uma mensagem de erro informando que o email já existe

  Scenario: Cadastro com email em formato inválido
    Given que o usuário está na tela de cadastro
    When ele informa um nome válido
    And informa um email em formato inválido
    And informa uma senha válida
    Then o sistema não deve cadastrar o usuário
    And deve exibir uma mensagem de erro informando que o email é inválido

  Scenario: Cadastro com senha que não atende aos requisitos mínimos
    Given que o usuário está na tela de cadastro
    When ele informa um nome válido
    And informa um email válido
    And informa uma senha que não atende aos requisitos mínimos de complexidade
    Then o sistema não deve cadastrar o usuário
    And deve exibir uma mensagem de erro informando os requisitos mínimos de senha

  Scenario: Cadastro com confirmação de senha divergente
    Given que o usuário está na tela de cadastro
    When ele informa um nome válido
    And informa um email válido
    And informa uma senha válida
    And confirma com uma senha diferente da informada
    Then o sistema não deve cadastrar o usuário
    And deve exibir uma mensagem de erro informando que as senhas não conferem

  Scenario: Cadastro com campo obrigatório em branco
    Given que o usuário está na tela de cadastro
    When ele deixa o campo nome em branco
    And informa um email válido
    And informa uma senha válida
    Then o sistema não deve cadastrar o usuário
    And deve exibir uma mensagem de erro indicando que o nome é obrigatório
