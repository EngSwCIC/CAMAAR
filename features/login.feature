Feature: User login

  Scenario: Logging in with valid admin credentials
    Given There is a valid administrator
    When I login with default administrator credentials
    Then I should be logged in to the system as an administrator

  Scenario: Incorrect credentials entered
    When I login with the credentials:
      | email    | 'vanessa@gmail.com' |
      | password | '123'               |
    Then the login should fail
