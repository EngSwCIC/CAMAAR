Feature: Create a template form
    As an Administrator
    I want to create a template containing questions
    So that I can generate evaluation forms to assess the performance of the classes


    Background: I am an Coordinator
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        When I follow "Templates"
        Then I should be on the "Templates" page

    Scenario: Coordinator succesfully creates a form template
        When I press the button "Adicionar Template"
        Then I should be on the "Crie um Novo Template" page

        And I fill in "template_name" with "Template 1"
        And I create question 1 as a multiple choice question "Classifique seu rendimento" with the options "Bom" "Médio" "Ruim" "Péssimo"
        And I create question 2 as a text question "Dê uma sugestão"

        When I press the button "Salvar Template"
        Then I should be on the "Templates" page
        And I should see "Template 1"

    Scenario: Coordinator fails to create a form template due to missing information
        When I press the button "Adicionar Template"
        Then I should be on the "Crie um Novo Template" page

        And I fill in "template_name" with "Template 1"

        When I press the button "Salvar Template"
        Then I should see "O template precisa conter pelo menos uma pergunta"
