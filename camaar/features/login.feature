# Eu como usuário do sistema
# Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
# A fim de responder formulários ou gerenciar o sistema

Feature: Login

  Scenario: Correct credentials
    Given I'm a registered user
    And I'm on the Login page
    When I fill the email textfield with my email
    And I fill the password textfield with my password
    And I click on the submit button
    Then I should be on the Home page

  Scenario: Empty password field
    Given I'm a registered user
    And I'm on the Login page
    When I fill the email textfield with my email
    And I click on the submit button
    Then I should be prompted with "Preencha o campo com a senha da sua conta."

  Scenario: Empty email field
    Given I'm a registered user
    And I'm on the Login page
    When I fill the password textfield with my password
    And I click on the submit button
    Then I should be prompted with "Preencha o campo com seu email."

  Scenario: Both fields are empty
    Given I'm a registered user
    And I'm on the Login page
    When I click on the submit button
    Then I should be prompted with "Preencha os campos necessários."

  Scenario: Wrong password
    Given I'm a registered user
    And I'm on the Login page
    When I fill the email textfield with my email
    And I fill the password textfield with the wrong password
    And I click on the submit button
    Then I should be prompted with "Usuário e/ou senha inválidos."

  Scenario: Wrong email
    Given I'm a registered user
    And I'm on the Login page
    When I fill the email textfield with the wrong email
    And I fill the password textfield with my password
    And I click on the submit button
    Then I should be prompted with "Usuário e/ou senha inválidos."

