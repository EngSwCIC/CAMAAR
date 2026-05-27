Feature: Fazer Login como usuário
  Como um usuário cadastrado no CAMAAR,
  Quero conseguir realizar o login com minhas credenciais
  Para que eu tenha acesso às funcionalidades disponíveis para o meu perifl

  Background:
    Given que o usuário está na tela de login

  Scenario: Login realizado com sucesso
    When ele informa um email cadastrado
    And informa a senha correta
    And clica em "entrar"
    Then o sistema deve autenticar o usuário
    And deve redirecionar para a tela inicial do sistema

  Scenario: Login com email não cadastrado
    When ele informa um email que não está cadastrado no sistema
    And informa uma senha qualquer
    And clica em "entrar"
    Then o sistema não deve autenticar o usuário
    And deve exibir uma mensagem de erro informando que as credenciais são inválidas

    Scenario: Login com email em formato invalido
      When ele informa o email "joao.silva.email.com"
      And informa uma senha qualquer
      And clica em "entrar"
      Then o sistema não deve autenticar o usuário
      And deve exibir uma mensagem de erro informando que o email é inválido

      Scenario: Login com campo de email em branco
        When ele deixa o campo email em brnaco
        And informa uma senha qualquer
        And clica em "entrar"
        Then o sistema não deve autenticar o usuário
        And deve exibir uma mensagem de erro indicando que o email é obrigatório

      Scenario: Login com campo de senha em branco
        When ele informa um email cadastrado
        And deixa o campo senha em brnaco
        And clica em "entrar"
        Then o sistema não deve autenticar o usuário
        And deve exibir uma mensagem de erro indicando que a senha é obrigatória



