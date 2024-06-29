Feature: View Form Results
Background: The user is logged in as a coordinator
Given the user is logged in as a coordinator

Scenario: Coordinator views the list of available forms
	Given the user is on the forms page
	When the user clicks on "View all forms"
	Then the user should see a list of forms created by them

Scenario: Coordinator views the results of a specific form
	Given the user is on the forms page
	And there is at least one form created by the coordinator
	When the user clicks on a specific form
	Then the user should see the results of the selected form

Scenario: Coordinator tries to view results when no forms are created
	Given the user is on the forms page
	And there are no forms created by the coordinator
	When the user clicks on "View all forms"
	Then the user should see a message "No forms found"

Scenario: Coordinator views charts and statistics of the form results
	Given the user is viewing the results of a specific form
	When the user clicks on "View charts and statistics"
	Then the user should see detailed charts and statistics of the form results
