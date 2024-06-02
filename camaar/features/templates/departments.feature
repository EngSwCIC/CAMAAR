Feature: Manage classes from department
    As a Coordinator
    I want to manage only the classes of the department to which I belong
    So that I can evaluate the performance of the classes in the current semester

    Background: I am an Coordinator
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        When I follow "Turmas"
        Then I should be on the "Meu Departamento" page
        Then I should see "DEPTO CIÊNCIAS DA COMPUTAÇÃO"

    Scenario: Coordinator acess department page
        Given that I imported classes for the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Then I should only see classes starting with "CIC"

    Scenario: Coordinator has not imported classes data
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        When I follow "Turmas"
        Then I should see "Não foram encontradas turmas para o departamento"




