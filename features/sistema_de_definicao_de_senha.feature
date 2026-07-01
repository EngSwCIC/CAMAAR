Feature: Definir senha do usuário

  Eu como Usuário
  Quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro
  A fim de acessar o sistema

  Background:
    Given que uma solicitação de cadastro foi enviada para o meu e-mail
    And que eu acessei o link recebido no e-mail de solicitação de cadastro
    And que estou na página de definição de senha
    
@happy_path
  Scenario: Definir senha com sucesso (happy path)
    When eu preencho o campo "Senha" com "SenhaForte123!"
    And eu preencho o campo "Confirmar Senha" com "SenhaForte123!"
    And eu clico em "Salvar Senha"
    Then eu devo ver a mensagem "Senha definida com sucesso"
    And devo ser redirecionado para a página inicial de login do sistema

@sad_path
  Scenario: Tentar definir senha com confirmação diferente (sad path)
    When eu preencho o campo "Senha" com "SenhaForte123!"
    And eu preencho o campo "Confirmar Senha" com "SenhaIncorreta456!"
    And eu clico em "Salvar Senha"
    Then eu devo ver a mensagem "As senhas não coincidem"
    And devo permanecer na página de definição de senha