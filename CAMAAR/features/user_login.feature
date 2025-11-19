Feature: User Login

  Scenario: User logs in successfully
    Given I am on login page
    When I enter a valid email
    And I enter the correct password
    Then I should see the homepage

  Scenario: User with email does not exist
    Given I am on login page
    When I enter a email that does not exist on database
    Then I should see an error message that user does not exist

  Scenario: User password is wrong
    Given I am on login page
    When I enter a valid email
    And I enter the wrong password
    Then I should see an error message that the password is wrong

  Scenario: User logged in is admin
    Given I am an admin user
    When I log in successfully
    Then I should see the gerenciamento tab on the side menu
