Feature: User login

  Scenario: Logging in with valid admin credentials
    Given There is a valid administrator
    When I login with default administrator credentials
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
