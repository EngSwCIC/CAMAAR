Feature: User login

  Scenario: Logging in with valid admin credentials
    Given I am an administrator
    When I login with the following credentials:
      | email    | coordenador@gmail.com |
      | password | TOKEN_587             |
    Then I should be logged in to the system as an administrator
  #   Given I am on the login page
  #   When I enter my registration number
  #   And I enter my password
  #   And I click the "Login" button
  #   Then I should be logged in to the system
  # Scenario: Attempt to log in with incorrect credentials
  #   Given I am on the login page
  #   When I enter incorrect email or registration number
  #   And I enter incorrect password
  #   And I click the "Login" button
  #   Then I should see an error message "Incorrect email, registration number, or password. Please try again."
