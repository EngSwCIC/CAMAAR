Feature: User Password Setup

  Scenario: User sets password successfully
    Given I received a registration email
    When I click on the registration link
    And I enter a valid password
    And I confirm the password correctly
    Then I should see a success message
    And I should be able to log in with my credentials

  Scenario: Passwords do not match
    Given I received a registration email
    When I click on the registration link
    And I enter a valid password
    And I enter a different password in the confirmation field
    Then I should see an error message that passwords do not match

  Scenario: Password already created
    Given I already have a password
    When I click on the registration link
    Then I should see an error message that password already registered
