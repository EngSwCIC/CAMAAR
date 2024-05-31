Feature: Create a form for teachers of a class
    As a Coordinator
    I want to choose to create a form for the teachers of the classes I choose
    So that I can evaluate the performance of the classes in the current semester

    Background: I am a Coordinator on the templates page
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given the following classes exists:
            | name            | semester | subject | classCode | schedule |
            | BANCOS DE DADOS | 2021.2   | CIC0097 | TA        | 35T45    |
        When I follow "Envio"
        Then I should be on the "Envio" page
        And I should see "Selecione as opções para envio"
        Given that I created the template "Template 1" for teachers
        When I select "Professores" from the "Enviar para" field

    Scenario: Dispatch form for teachers of a class
        Then I should see "Selecione template para os professores"
        When I click on the combobox "Template professores"
        Then I should see the options:
            | name       |
            | selecione  |
            | Template 1 |
        When I select "Template 1" from "Template professores" field
        Then I should see "Template 1"

        Then I should see "Selecione as turmas"
        And I should see the following:
            | name            | subject | semester | classCode | schedule |
            | BANCOS DE DADOS | CIC0097 | 2021.2   | TA        | 35T45    |
        When I check the "CIC0097_2021.2_TA"  checkbox
        When I press the button "Enviar"
        Then I should be on the "Resultados" page
        And I should see the forms:
            | template   | class                 | role    | status  |
            | Template 1 | CIC0097 - 2021.2 - TA | teacher | pending |


    Scenario: Coordinator have not created any teacher template
        Then I should see "Selecione template para os professores"
        When I click on the combobox "Template professores"
        Then I should see the options:
            | name      |
            | selecione |

        Then I should see "Selecione as turmas"
        And I should see the following:
            | name            | subject | semester | classCode | schedule |
            | BANCOS DE DADOS | CIC0097 | 2021.2   | TA        | 35T45    |
        When I check the "CIC0097_2021.2_TA"  checkbox
        When I press the button "Enviar"

        Then I should see the erro mesage "Selecione um template para os professores"


# Scenario: There are no classes in the current semester
#     Given I am on the "Envio" page
#     Then I should see "Não há turmas disponíveis para envio"