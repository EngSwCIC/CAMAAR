Feature: Manage classes from department
    As a Coordinator
    I want to manage only the classes of the department to which I belong
    So that I can evaluate the performance of the classes in the current semester

    Background: I am an Coordinator
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        When I follow "Turmas"
        Then I expect to be on the "Meu Departamento" page
        Then I expect to see "DEPTO CIÊNCIAS DA COMPUTAÇÃO"

    Scenario: Coordinator acess department page
        Then I expect to only see classes starting with "CIC"

    Scenario: Coordinator has not imported classes data
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        When I follow "Turmas"
        Then I expect to see "Não foram encontradas turmas para o departamento"




