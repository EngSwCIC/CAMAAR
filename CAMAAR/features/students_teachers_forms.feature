Feature: Create Forms for Students or Teachers

  Scenario: Successfully create form for teachers
    Given I am an admin
    And I am on the gerenciamento page
    And there are available templates
    And there are classes with teachers
    When I click the send form button
    And I select a template
    And I select "docentes" as the target group
    And I select at least one class
    Then I should see a success message
    And the new form should be assigned to teachers of the selected classes
    And the form should be available for teachers to fill out
    And the new form should be available on the gerenciamento - resultados page

  Scenario: Successfully create form for students
    Given I am an admin
    And I am on the gerenciamento page
    And there are available templates
    And there are classes with students
    When I click the send form button
    And I select a template
    And I select "dicentes" as the target group
    And I select at least one class
    Then I should see a success message
    And the new form should be assigned to students of the selected classes
    And the form should be available for students to fill out
    And the new form should be available on the gerenciamento - results page

  Scenario: Tried to create form without selecting target group
    Given I am an admin
    And I am on the gerenciamento page
    When I click the send form button
    And I select a template
    And I select at least one class
    And I do not select a target group
    Then I should see an error message that I need to select either docentes or dicentes

  Scenario: Tried to create form for teachers without selecting template
    Given I am an admin
    And I am on the gerenciamento page
    When I click the send form button
    And I select "docentes" as the target group
    And I select at least one class
    And I do not select a template
    Then I should see an error message that I need to select a template

  Scenario: Tried to create form for students without selecting classes
    Given I am an admin
    And I am on the gerenciamento page
    When I click the send form button
    And I select a template
    And I select "dicentes" as the target group
    And I do not select any class
    Then I should see an error message that I need to select at least one class

  Scenario: Create form for teachers when no teachers exist in selected class
    Given I am an admin
    And I am on the gerenciamento page
    And there are available templates
    And there is a class with no teachers
    When I click the send form button
    And I select a template
    And I select "docentes" as the target group
    And I select the class with no teachers
    Then I should see a warning message that the selected class has no teachers
    And the form should not be created

  Scenario: Create form for students when no students exist in selected class
    Given I am an admin
    And I am on the gerenciamento page
    And there are available templates
    And there is a class with no students
    When I click the send form button
    And I select a template
    And I select "dicentes" as the target group
    And I select the class with no students
    Then I should see a warning message that the selected class has no students
    And the form should not be created
