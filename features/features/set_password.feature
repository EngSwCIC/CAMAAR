Feature: Set password
  As a Student
  I want to set my password in the system, through the registration request email
  So that I can access the system using the password I defined

  Background: Starting at the password setting page
    Given I am on the Definir Senha page

  Scenario: The set password is valid (happy path)
    When I fill in "Senha" with "12345"
    And I fill in "Confirme a Senha" with "12345"
    Then I should see "Senha registrada com sucesso"
    Then I can use the features of a registered user

  Scenario: The set password is invalid (sad path)
    When I click "Alterar senha"
    Then I should be on the Definir senha page
    And I should see "A senha registrada é inválida"

