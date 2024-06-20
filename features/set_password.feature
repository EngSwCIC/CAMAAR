Feature: Set password
  As a Student
  I want to set my password in the system, through the registration request email
  So that I can access the system using the password I defined

  Background: Starting at the password setting page
    Given There is a user with email "teste@email.com" and matricula "123456789" and password "abcdef"
    And I have a reset password token
    And I am on the Definir Senha page

  Scenario: The set password is valid (happy path)
    When I fill in "Senha" with "123456"
    And I fill in "Confirme a senha" with "123456"
    When I press "Alterar senha"
    Then I should see "Senha registrada com sucesso"
    Then I should be on the Avaliacoes page

  Scenario: The set password is invalid (sad path)
    When I fill in "Senha" with ""
    And I fill in "Confirme a senha" with ""
    When I press "Alterar senha"
    Then I should be on the Definir Senha page
    And I should see "A senha registrada é inválida"