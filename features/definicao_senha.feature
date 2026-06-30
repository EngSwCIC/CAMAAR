Feature: Definição de senha para novo usuário

  Como um novo usuário cadastrado via importação do SIGAA,
  Quero conseguir definir minha senha de acesso pelo link enviado ao meu email
  Para que eu consiga fazer login no sistema pela primeira vez

  Background:
    Given que existe um novo usuário importado do SIGAA sem senha definida

  Scenario: Definição de senha realizada com sucesso
    Given que o usuário acessa o link de convite recebido por email
    When preenche a nova senha no campo senha
    And preenche a mesma senha no campo de confirmação
    And clica em "Redefinir senha"
    Then o sistema deve salvar a senha do usuário
    And o usuário deve conseguir realizar login com a senha definida

  Scenario: Definição de senha que não atende aos requisitos mínimos
    Given que o usuário acessa o link de convite recebido por email
    When preenche uma senha que não atende aos requisitos no campo senha
    And preenche a mesma senha no campo de confirmação
    And clica em "Redefinir senha"
    Then o sistema não deve salvar a senha do usuário
    And deve exibir uma mensagem de erro informando os requisitos mínimos de senha

  Scenario: Definição de senha com confirmação divergente
    Given que o usuário acessa o link de convite recebido por email
    When preenche a nova senha no campo senha
    And preenche uma senha diferente no campo de confirmação
    And clica em "Redefinir senha"
    Then o sistema não deve salvar a senha do usuário
    And deve exibir uma mensagem de erro informando que as senhas não coincidem

  Scenario: Definição de senha com campos em branco
    Given que o usuário acessa o link de convite recebido por email
    When deixa o campo senha em branco
    And deixa o campo de confirmação em branco
    And clica em "Redefinir senha"
    Then o sistema não deve salvar a senha do usuário
    And deve exibir uma mensagem de erro indicando que a nova senha é obrigatória

  Scenario: Acesso com link de convite inválido ou expirado
    Given que o usuário possui um link de convite inválido ou expirado
    When tenta acessar a página de definição de senha
    Then o sistema deve redirecionar para a página de recuperação de senha
    And deve exibir uma mensagem informando que o link é inválido ou expirou
