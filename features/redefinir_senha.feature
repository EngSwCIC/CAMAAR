Feature: Redefinir senha do usuário

  Como usuário
  Quero conseguir redefinir minha senha
  Para que eu consiga ter acesso garantido à minha conta caso perca a credencial

  Scenario: Redefinição de senha realizada com sucesso
    Given que o usuário está na tela de redefinição de senha
    When ele coloca a nova senha no primeiro campo
    And ele coloca a mesma nova senha no segundo campo
    And ele clica em "mudar de senha"
    Then o sistema deve mudar a senha de acesso desse usuário

  Scenario: Redefinição de senha com campos diferentes
    Given que o usuário está na tela de redefinição de senha
    When ele coloca a nova senha no primeiro campo
    And ele coloca uma nova senha diferente no segundo campo
    And ele clica em "mudar de senha"
    Then o sistema deve exibir uma mensagem de erro informando que as duas senhas não batem

  Scenario: Redefinição com nova senha que não atende aos requisitos mínimos
    Given que o usuário está na tela de redefinição de senha
    When ele coloca uma senha que não atende aos requisitos mínimos no primeiro campo
    And ele coloca a mesma senha no segundo campo
    And ele clica em "mudar de senha"
    Then o sistema não deve alterar a senha do usuário
    And deve exibir uma mensagem de erro informando os requisitos mínimos de senha

  Scenario: Redefinição com nova senha igual à senha atual
    Given que o usuário está na tela de redefinição de senha
    When ele coloca a senha atual no primeiro campo
    And ele coloca a mesma senha no segundo campo
    And ele clica em "mudar de senha"
    Then o sistema não deve alterar a senha do usuário
    And deve exibir uma mensagem de erro informando que a nova senha deve ser diferente da atual

  Scenario: Redefinição com campos em branco
    Given que o usuário está na tela de redefinição de senha
    When ele deixa o primeiro campo em branco
    And ele deixa o segundo campo em branco
    And ele clica em "mudar de senha"
    Then o sistema não deve alterar a senha do usuário
    And deve exibir uma mensagem de erro indicando que a nova senha é obrigatória

  Scenario: Redefinição com link de redefinição expirado
    Given que o usuário está na tela de redefinição de senha
    And que o link de redefinição utilizado pelo usuário já expirou
    When ele coloca uma nova senha no primeiro campo
    And ele coloca a mesma senha no segundo campo
    And ele clica em "mudar de senha"
    Then o sistema não deve alterar a senha do usuário
    And deve exibir uma mensagem informando que o link expirou
    And deve oferecer a opção de solicitar um novo link
