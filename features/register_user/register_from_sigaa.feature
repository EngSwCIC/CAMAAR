Feature: Register participants via SIGAA import
  As an Administrator
  I want to register participants when importing data of new users from SIGAA
  So that they can access the CAMAAR system

  Note: Registration is only completed after the user sets their password via the email received.

  Background:
    Given I am logged in as the "Administrador" profile
    And I navigate to the "Importação SIGAA" page

  Scenario: [Happy Path] Request password setup for new participants
    Given a SIGAA file containing the new participant "maria@unb.br" is available
    And no user is registered with the email "maria@unb.br"
    When I upload the SIGAA participants file
    And I click the "Register Participants" button
    Then the system should create a registration request for "maria@unb.br"
    And a password setup email should be sent to "maria@unb.br"
    And the user "maria@unb.br" should appear with status "Aguardando definição de senha"

  Scenario: Registration completed after password setup
    Given there is a pending registration request for "maria@unb.br"
    When the user "maria@unb.br" accesses the password setup link received by email
    And the user sets the password "SenhaForte123"
    Then the registration of "maria@unb.br" should be completed
    And the user "maria@unb.br" should appear with status "Ativo"

  Scenario: [Sad Path] Already registered participant is ignored
    Given a user already exists with email "joao@unb.br"
    And a SIGAA file containing the participant "joao@unb.br" is available
    When I upload the SIGAA participants file
    And I click the "Register Participants" button
    Then the system should not send a new email to "joao@unb.br"
    And I should see the message "Usuário joao@unb.br já cadastrado, ignorado"
