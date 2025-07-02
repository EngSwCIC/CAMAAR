Feature: Register users to the system
  As an Administrator
  I want to register SIGAA class participants when importing new user data into the system
  So that they can access the CAMAAR system

  Background:
    Given I have valid SIGAA JSON files
    And I am logged in as an administrator

  Scenario: Register new users and request password definition
    Given I am on the management page
    And there are no users registered in the system
    When I press "Importar dados"
    Then I should see the message "Usuários cadastrados com sucesso."
    And each new user should be saved with status "pending"
    And each user should receive an email with a “Set your password” link

  Scenario: Activate account after user defines password
    Given a user has a pending account with registration "202112345"
    When the user defines a password "Mypass"
    Then the account should be activated
    And the user should see the message "Conta ativada com sucesso"

  Scenario: Skip users that already have active accounts
    Given all users in the SIGAA file already have active accounts
    When I press "Importar dados"
    Then I should see the message "Sem novos usuários."
    And no duplicate accounts should be created

  Scenario: SIGAA file contains only existing users
    Given the database already contains all users from the JSON
    When I import the SIGAA participant data
    Then the system should not create or modify any user
    And I should see the message "Sem novos usuários a serem cadastrados"
