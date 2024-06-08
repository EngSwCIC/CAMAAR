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
        
        When I press "Add Question"
        Then I expect to be on the "Add Question" page
        When I select "Múltipla escolha" from "question type"
        When I select "5" from "options number"
        When I fill in the following:
            | title   | Classifique seu rendimento |
            | option1 | Ótimo                      |
            | option2 | Bom                        |
            | option3 | Médio                      |
            | option4 | Ruim                       |
            | option5 | Péssimo                    |
        When I press "Add"

        Then I expect to be on the "New Template" page
        Then I expect to see "Questão 1"
        
        When I press "Add Question"
        Then I expect to be on the "Add Question" page
        When I select "Texto" from "question type"
        When I fill in the following:
            | title | Dê uma sugestão |
        When I press "Add"

        Then I expect to be on the "New Template" page
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
