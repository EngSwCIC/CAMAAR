Feature: Reset Password
Background: The user is on the login page
Given the user is on the login page

Scenario: User requests password reset with a valid email
	Given the user clicks on "Forgot password?"
	When the user enters a valid email
	And clicks on "Send"
	Then the user should see a message "Instructions to reset your password have been sent to your email"

Scenario: User requests password reset with an invalid email
	Given the user clicks on "Forgot password?"
	When the user enters an invalid email
	And clicks on "Send"
	Then the user should see a message "Invalid email, please try again"

Scenario: User attempts to reset password with a valid token
	Given the user received the password reset email
	And the user clicks on the reset link in the email
	When the user enters a new valid password
	And confirms the new password
	And clicks on "Reset password"
	Then the user should see a message "Password successfully reset"

Scenario: User attempts to reset password with an invalid token
	Given the user clicked on an invalid or expired password reset link
	When the user attempts to reset the password
	Then the user should see a message "Invalid or expired token, please request a new password reset"
