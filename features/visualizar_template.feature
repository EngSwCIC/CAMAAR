Feature: View Template
Background: The user is logged in as a coordinator
Given the user is logged in as a coordinator

Scenario: Coordinator views the list of available templates
	Given the user is on the templates page
	When the user clicks on "View all templates"
	Then the user should see a list of templates created by them

Scenario: Coordinator views details of a specific template
	Given the user is on the templates page
	And there is at least one template created by the coordinator
	When the user clicks on a specific template
	Then the user should see the details of the selected template

Scenario: Coordinator tries to view templates when no templates are created
	Given the user is on the templates page
	And there are no templates created by the coordinator
	When the user clicks on "View all templates"
	Then the user should see a message "No templates found"
