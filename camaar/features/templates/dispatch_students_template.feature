Feature: Create a form for students of a class
    As a Coordinator
    I want to choose to create a form for the students of the classes I choose
    So that I can evaluate the performance of the classes in the current semester

    Background: I am a Coordinator on the templates page
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given the following classes exists:
            | name            | semester | subject | classCode | schedule |
            | BANCOS DE DADOS | 2021.2   | CIC0097 | TA        | 35T45    |
        When I follow "Envio"
        Then I should be on the "Envio" page
        And I should see "Selecione as opções para envio"
        Given that I created the template "Template 2" for students
        When I select "Alunos" from the "Enviar para" field


    Scenario: Dispatch form for students of a class
        Then I should see "Selecione template para os alunos"
        When I click on the combobox "Template alunos"
        Then I should see the options:
            | name       |
            | selecione  |
            | Template 2 |
        When I select "Template 2" from "Template alunos" field
        Then I should see "Template 2"

        Then I should see "Selecione as turmas"
        And I should see the following:
            | name            | subject | semester | classCode | schedule |
            | BANCOS DE DADOS | CIC0097 | 2021.2   | TA        | 35T45    |
        When I check the "CIC0097_2021.2_TA"  checkbox
        When I press the button "Enviar"
        Then I should be on the "Resultados" page
        And I should see the forms:
            | template   | class                 | role    | status  |
            | Template 2 | CIC0097 - 2021.2 - TA | student | pending |

    Scenario: Coordinator have not created any student template
        Then I should see "Selecione template para os alunos"
        When I click on the combobox "Template alunos"
        Then I should see the options:
            | name      |
            | selecione |

        Then I should see "Selecione as turmas"
        And I should see the following:
            | name            | subject | semester | classCode | schedule |
            | BANCOS DE DADOS | CIC0097 | 2021.2   | TA        | 35T45    |
        When I check the "CIC0097_2021.2_TA"  checkbox
        When I press the button "Enviar"

        Then I should see the erro mesage "Selecione um template para os alunos"

# Scenario: There are no classes in the current semester
#     Given I am on the "Envio" page
#     Then I should see "Não há turmas disponíveis para envio"