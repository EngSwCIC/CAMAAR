Feature: Set password after registration request

  As a User
  I want to define a password for my account after receiving the registration request email
  So that I can access the system

  Background:
    Given a pending user account exists for "usuario@gmail.com" with registration number "210154345"
    And a registration request email was sent to "usuario@gmail.com" with a password setup link

  Scenario: Define a password from the registration email link
    When the user clicks the password setup link in the email
    And she enters the password "123456"
    And confirms the password as "123456"
    And submits the form
    Then her account should be activated
    And she should see the message "Senha definida"
    And she should be redirected to the login page

  Scenario: Attempt to set a invalid password
    When the user clicks the password setup link in the email
    And she enters the password "123" and confirms "123"
    And submits the form
    Then the system should show an error message "Senha inválida"
