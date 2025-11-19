Feature: Definir senha após cadastro
  Como Usuário
  Quero definir uma senha para o meu usuário a partir do email do sistema de solicitação de cadastro
  A fim de acessar o sistema

  Background:
    Given que recebi um email de convite para cadastro
    And o email contém um link de ativação

  Scenario: Definir senha com sucesso (feliz)
    Given que clico no link de ativação do email
    When eu sou redirecionado para a página de definição de senha
    And eu preencho uma senha segura
    And eu confirmo a senha
    And eu clico em "Definir senha"
    Then a minha senha deve ser criada
    And eu devo receber a mensagem "Senha definida com sucesso"
    And eu devo ser redirecionado para login

  Scenario: Senhas não conferem (triste)
    Given que estou na página de definição de senha
    When eu preencho a senha "Senha123!"
    And eu confirmo com uma senha diferente "Senha456!"
    And eu clico em "Definir senha"
    Then o sistema deve exibir a mensagem "As senhas não conferem"
    And a senha não deve ser criada

  Scenario: Senha muito fraca (triste)
    Given que estou na página de definição de senha
    When eu preencho uma senha fraca "123"
    And eu confirmo a mesma senha
    And eu clico em "Definir senha"
    Then o sistema deve exibir a mensagem "Senha fraca. Use letras, números e caracteres especiais"
    And a senha não deve ser criada

  Scenario: Link de ativação expirado (triste)
    Given que o link de ativação expirou
    When eu clico no link
    Then o sistema deve exibir a mensagem "Link de ativação expirado"
    And eu devo ser orientado a solicitar um novo link