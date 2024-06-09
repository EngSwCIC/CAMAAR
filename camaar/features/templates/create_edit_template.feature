Feature: Create/Edit a template form
    As an Administrator
    I want to create/edit a template containing questions
    So that I can generate evaluation forms to assess the performance of the classes


    Background: I am an Coordinator on the templates page
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        When I follow "Templates"
        Then I expect to be on the "Templates" page

    Scenario: Coordinator succesfully creates template
        When I press "Add template"
        Then I expect to be on the "New Template" page


        When I create a "Múltipla escolha" question with the following:
            | title   | Classifique seu rendimento |
            | option1 | Ótimo                      |
            | option2 | Bom                        |
            | option3 | Médio                      |
            | option4 | Ruim                       |
            | option5 | Péssimo                    |
        Then I expect to see "Questão 1"

        When I create a "Texto" question with the following:
            | title | Dê uma sugestão |
        Then I expect to see "Questão 2"

        And I fill in "Name" with "Template 1"
        When I press "Save"
        Then I expect to be on the "Templates" page
        And I expect to see "Template 1"

    Scenario: Template has missing information
        When I press "Add Template"
        Then I expect to be on the "New Template" page

        And I fill in "name" with "Template 1"

        When I press "Save"
        Then I expect to see "O template precisa conter pelo menos uma pergunta"
