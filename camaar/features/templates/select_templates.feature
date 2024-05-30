Feature: Choose template type
    As a Coordinator
    I want to choose to create a form for the teachers or students of a class
    So that I can evaluate the performance of a subject

    Background: I am a Coordinator on the templates page
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        When I follow "Envio"
        Then I should be on the "Envio" page

    Example:
        There are 3 created templates

        | <template_name_1> |
        | <template_name_2> |
        | <template_name_3> |

    Scenario: There are created templates for teachers
        Given I am on the "Envio" page
        When I click on the combobox associated with the "Template professores" field
        Then I should see the following options in the combobox:
            | <template_name_1> |
            | <template_name_2> |
            | <template_name_3> |
        When I select one of the options in the combobox
        Then I should see the "Template professores" field filled with the selected option

    Scenario: There are created templates for students
        Given I am on the "Envio" page
        When I click on the combobox associated with the "Template alunos" field
        Then I should see the following options in the combobox:
            | <template_name_1> |
            | <template_name_2> |
            | <template_name_3> |
        When I select one of the options in the combobox
        Then I should see the "Template alunos" field filled with the selected option

    Scenario: There are no created templates (teachers)
        Given I am on the "Envio" page
        When I click on the combobox associated with the "Template professores" field
        Then I should see the following options in the combobox:
            | Nenhum template criado |
        And I cannot select any option in the combobox

    Scenario: There are no created templates (students)
        Given I am on the "Envio" page
        When I click on the combobox associated with the "Template alunos" field
        Then I should see the following options in the combobox:
            | Nenhum template criado |
        And I cannot select any option in the combobox
