Feature: Manage classes from department
    As a Coordinator
    I want to manage only the classes of the department to which I belong
    So that I can evaluate the performance of the classes in the current semester

    Background: I am an Coordinator
        Given I am an authenticated Coordinator
        When I follow "Turmas"
        Then I should be on the page "Turmas do Departamento"

    Scenario: Coordinator acess department classes page
        And I should see "DEPTO CIÊNCIAS DA COMPUTAÇÃO - CIC"
        And I should see the class "CIC0097"
        And I should see the class "CIC0105"
        And I should see the class "CIC0105"

