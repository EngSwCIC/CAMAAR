Feature: Set a new password
  As a user or administrator, I want to set a new password in the system

Background: I am a user that needs to set a password
  Given I've already a log in on the system 

Scenario: User successfully sets a password (Happy path)
  Given I am on the "Set Password" page
  When I fill in the password fields with valid information
  And I click on 'Save Password'
  Then I should see "Password set successfully"

Scenario: User tries to set a new password with missing information (Sad path)
  Given I am on the "Set Password" page
  When I leave a password field empty
  And I click on 'Save Password'
  Then I should see "Error, please fill in all password fields"

Scenario: User tries to set a new password with a weak password (Sad path)
  Given I am on the "Set Password" page
  When I fill in the password field with a weak password
  And I click on 'Save Password'
  Then I should see "Error, the password is too weak. Please choose a stronger password"

Scenario: User tries to set a new password with non-matching passwords (Sad path)
  Given I am on the "Set Password" page
  When I fill in the password and confirmation password fields with different values
  And I click on 'Save Password'
  Then I should see "Error, the passwords do not match"

Scenario: User tries to set a new password with an invalid format (Sad path)
  Given I am on the "Set Password" page
  When I fill in the password field with an invalid format
  And I click on 'Save Password'
  Then I should see "Error, the password entered is not in the correct format. Please enter a valid password"
