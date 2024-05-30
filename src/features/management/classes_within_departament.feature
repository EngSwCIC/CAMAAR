Feature: Managing classes within a department
    As an administrator
    I want to manage only the classes of the department I belong to
    So that I can evaluate the performance of the classes in the current semester

  Background:
    Given that I am logged in as an administrator
    And I belong to the "Computer Science" department

  Scenario: Admin views the list of classes in their department
    When I go to the department's classes page
    Then I should see my department's class list

  Scenario: Admin views no classes in their department
    Given there are no classes in the "Computer Science" department for the current semester
    When I go to the department classes page
    Then I should see a message "Nenhuma turma cadastrada nesse departamento"

  Scenario: Admin from another department tries to view classes
    Given I belong to the "Business" department
    When I go to the department classes page
    Then I should see list of "Business" department
    And I should not see list of the "Computer Science" department

  Scenario: Regular user tries to access the department classes page
    Given I am logged in as a regular user
    When I go to the department classes page
    Then I should see an error message "Você deve ser administrador para acessar essa página."