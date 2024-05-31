Feature: Department Management System
  As an administrator, I want to manage departments in the system to organize users and resources effectively

Background: I am a logged-in administrator
  Given I am logged in as an administrator

Scenario: Administrator successfully creates a new department (Happy path)
  Given I am on the "Create Department" page
  When I fill in the department details with valid information
  And I click on 'Create Department'
  Then I should see "Department created successfully"

Scenario: Administrator tries to create a department with missing information (Sad path)
  Given I am on the "Create Department" page
  When I leave a required field empty
  And I click on 'Create Department'
  Then I should see "Error, please fill in all required fields"

Scenario: Administrator successfully edits an existing department (Happy path)
  Given I am on the "Edit Department" page for "Department A"
  When I update the department details with valid information
  And I click on 'Save Changes'
  Then I should see "Department updated successfully"

Scenario: Administrator tries to edit a department with invalid information (Sad path)
  Given I am on the "Edit Department" page for "Department A"
  When I enter invalid information in a field
  And I click on 'Save Changes'
  Then I should see "Error, invalid information entered. Please correct the errors and try again"

Scenario: Administrator successfully deletes a department (Happy path)
  Given I am on the "Department List" page
  When I click on the 'Delete' button for "Department B"
  And I confirm the deletion
  Then I should see "Department deleted successfully"
  And "Department B" should no longer be listed

Scenario: Administrator tries to delete a department that does not exist (Sad path)
  Given I am on the "Department List" page
  When I click on the 'Delete' button for a non-existent department
  Then I should see "Error, department not found"

Scenario: Administrator views the list of departments (Happy path)
  Given I am on the "Department List" page
  Then I should see a list of departments
  And each department should have options to 'Edit' and 'Delete'

Scenario: Administrator tries to create a department with a duplicate name (Sad path)
  Given I am on the "Create Department" page
  When I fill in the department name with "Department C" which already exists
  And I click on 'Create Department'
  Then I should see "Error, department name already exists. Please choose a different name"
