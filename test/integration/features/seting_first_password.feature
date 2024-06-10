Feature: Set Password from Registration Request Email

  Scenario: Set password from registration request email
    Given I have received a registration request email with a link to set password
    When I open the email and click on the link
    Then I should be redirected to the set_password page
    And I enter my new password
    And I confirm my new password
    And I submit the password
    Then I should be redirected to the login page
    And I should see a success message "Your password has been successfully set. Please log in to access the system."

  Scenario: Attempt to set password with mismatched passwords
    Given I have received a registration request email with a link to set password
    When I open the email and click on the link
    Then I should be redirected to the set_password page
    And I enter my new password
    And I confirm a different password
    And I submit the password
    Then I should see an error message "Passwords do not match. Please make sure your passwords match."