Feature: Login System
  As a user, I can log into an account
Background: I am a user with a account
 Given I am a user with login "CaioFulano@gmail.com" and password "fluminense123"
 And I am on the login page
 
  Scenario: A user tries to log in with the wrong email

    When I fill 'Username' with 'thiago_joão@gmail.com'
    And I fill 'password' with 'fluminense123'
    And I click on 'log in'
    Then I should see "Email ou senha invalida'
   
  Scenario: A user tries to log in with the wrong password
    When I fill 'Username' with 'CaioFulano@gmail.com'
    And I fill 'password' with 'vasco123'
    And I click on 'log in'
    Then I should see "Email ou senha invalida'

  Scenario: A user tries to log in with correct email and password
    When I fill 'Username' with 'CaioFulano@gmail.com'
    And I fill 'password' with 'fluminense123'
    And I click on 'log in'
    Then the user is redirected to the home page

