Feature: Definir uma senha para o usuário a partir do e-mail
  Como Usuário
  Quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro
  A fim de acessar o sistema

  Scenario: Definição de senha com sucesso
    Given que eu recebi um e-mail do sistema de solicitação de cadastro
    When eu clico no link de definir minha senha no email recebido
    And eu sou redirecionado para página de redefinição de senha
    And eu coloco a nova senha
    And eu clico em salvar
    Then eu recebo a mensagem de senha cadastrada com sucesso

  Scenario: Falha na definição de senha
    Given que eu recebi um e-mail do sistema de solicitação de cadastro
    When eu clico no link de definir minha senha no email recebido
    And eu sou redirecionado para página de redefinição de senha
    And eu coloco a nova senha
    And eu clico em salvar
    Then eu recebo a mensagem de senha inválida
