Feature: Create a form for students and/or teachers of a class
    As a Coordinator
    I want to choose to create a form for the students and teachers of the classes I choose
    So that I can evaluate the performance of the classes in the current semester

    Background: I am a Coordinator on the templates page
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"

        Given that I created the teacher template "Template 1"
        Given that I created the student template "Template 2"

        When I follow "Envio"
        Then I expect to be on the "Dispatch" page
        And I expect to see "Opções para Envio"

        # And I expect to see "Nenhuma turma disponível"
        And I expect to see the following classes:
            | name                    | semester | subject | code | schedule |
            | BANCOS DE DADOS         | 2021.2   | CIC0097 | TA   | 35T45    |
            | ENGENHARIA DE SOFTWARE  | 2021.2   | CIC0105 | TA   | 35M12    |
            | PROGRAMAÇÃO CONCORRENTE | 2021.2   | CIC0202 | TA   | 35M34    |


    Scenario: Dispatch form for students of a class
        When I select "Template 2" from "Student template"
        Then I expect to see "Template 2"
        When I check "2021.2_CIC0097_TA"
        And I press "Confirm"
        Then I expect to see "O formulário para os alunos da turma BANCOS DE DADOS foi criado com sucesso."

    Scenario: Dispatch form for students of a class
        When I select "Template 1" from "Teacher template"
        Then I expect to see "Template 1"
        When I check "2021.2_CIC0097_TA"
        And I press "Confirm"
        Then I expect to see "O formulário para o professor da turma BANCOS DE DADOS foi criado com sucesso."

    Scenario: Coordinator forgets to select a class
        When I press "Confirm"
        Then I expect to see "Selecione as turmas para envio."

    Scenario: There are no classes in the current semester
        Given that the department "DEPTO CIÊNCIAS DA COMPUTAÇÃO" has no classes
        When I follow "Envio"
        Then I expect to see "Nenhuma turma disponível"

