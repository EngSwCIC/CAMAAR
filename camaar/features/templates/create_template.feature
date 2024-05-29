Feature: Create a template form
    As an Administrator
    I want to create a template containing questions
    So that I can generate evaluation forms to assess the performance of the classes


    Background: I am an Coordinator on the templates page
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        When I follow "Templates"
        Then I should be on the "Templates" page

    Scenario: Coordinator succesfully creates template
        When I press the button "Adicionar Template"
        Then I should be on the "Novo Template" page

        And I fill in "Nome do template" with "Template 1"
        And I create question 1 as a multiple choice question:
            | Caption                    | Option 1 | Option 2 | Option 3 | Option 4 |  |
            | Classifique seu rendimento | Bom      | Médio    | Ruim     | Péssimo  |  |
        And I create question 2 as a text question:
            | caption         |
            | Dê uma sugestão |

        When I press the button "Salvar Template"
        Then I should be on the "Templates" page
        And I should see "Template 1"

    Scenario: Template has missing information
        When I press the button "Adicionar Template"
        Then I should be on the "Novo Template" page

        And I fill in "Nome do template" with "Template 1"

        When I press the button "Salvar Template"
        Then I should see "O template precisa conter pelo menos uma pergunta"
