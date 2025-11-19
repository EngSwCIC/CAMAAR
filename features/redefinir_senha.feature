Feature: Redefinir senha
  Como Usuário
  Quero redefinir uma senha para o meu usuário a partir do email recebido após a solicitação da troca de senha
  A fim de recuperar o meu acesso ao sistema

  Background:
    Given que estou na página de login

  Scenario: Solicitar redefinição de senha com sucesso (feliz)
    Given que clico em "Esqueci minha senha"
    When eu preencho meu email "usuario@example.com"
    And eu clico em "Enviar link de recuperação"
    Then um email deve ser enviado para "usuario@example.com"
    And o email deve conter um link de redefinição
    And eu devo ver a mensagem "Email de recuperação enviado"

  Scenario: Redefinir senha com novo link (feliz)
    Given que recebi um email de recuperação de senha
    And eu clico no link de recuperação
    When eu sou redirecionado para a página de redefinição
    And eu preencho a nova senha
    And eu confirmo a nova senha
    And eu clico em "Atualizar senha"
    Then a minha senha deve ser atualizada
    And eu devo receber a mensagem "Senha atualizada com sucesso"

  Scenario: Link de recuperação expirado (triste)
    Given que o link de recuperação expirou
    When eu clico no link
    Then o sistema deve exibir a mensagem "Link expirado"
    And eu devo ser orientado a solicitar um novo link

  Scenario: Usuário não encontrado (triste)
    Given que estou na página de recuperação
    When eu preencho um email inexistente "naoexisto@example.com"
    And eu clico em "Enviar link de recuperação"
    Then o sistema deve exibir a mensagem "Email não encontrado"
    And nenhum email deve ser enviado