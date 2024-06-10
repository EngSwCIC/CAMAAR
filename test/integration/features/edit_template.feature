Feature: Edit Templates

    As an admin,
    I want to manage my form templates,
    So that I can make different types of forms.

    Background:
        Given I am logged in as an admin user 
        And the stored data is up to date
	And I am on the templates page

    Scenario: Create a valid template
        Given I have no templates
        When I click "Create Template"
	And I fill "Template Name" with "Template 1"
	And I choose "Text" for "Type"
	And I fill "Question" with "Who was Alan Turing?"
	And I click "Create"
	Then I should see "Template created successfully."
	And I should see "Template 1"	

    Scenario: Create an invalid template	
	Given I have no templates
        And I click "Create Template"
	And I click "Create"
	Then I should see "Fill in the necessary fields." 

    Scenario: Edit a valid template
	Given I have a template with name "Template 1"
	When I open "Template 1"
	And I fill "Template name" with "Template 2"
	And I click "Edit"
	Then I should see "Templated edited successfully."
	And I should see "Template 2"

    Scenario: Edit an invalid template
	Given I have a template with name "Template 1"
	When I open "Template 1"
	And I fill "Template name" with ""
	And I click "Edit"
	Then I should see "Fill in the necessary fields."

    Scenario: Delete a template
	Given I have templates with names "Template 1" and "Template 2"
	When I open "Template 1"
	And I click "Delete Template 1"
	And I click "Confirm"
	Then I should see "Template 2"
	And I should not see "Template 1"