Feature: Create a template form
    As an Administrator
    I want to create a template containing questions
    So that I can generate evaluation forms to assess the performance of the classes


    Background: I am an Coordinator on the templates page
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        When I follow "Templates"
        Then I expect to be on the "Templates" page

    Scenario: Coordinator succesfully creates template
        When I press "Adicionar Template"
        Then I expect to be on the "Novo Template" page

        And I fill in "Nome template" with "Template 1"
        And I create question 1 as a multiple choice question:
            | question                   | 1     | 2   | 3     | 4    | 5       |
            | Classifique seu rendimento | Ótimo | Bom | Médio | Ruim | Péssimo |
        And I create question 2 as a text question:
            | question        |
            | Dê uma sugestão |

        When I press "Salvar Template"
        Then I expect to be on the "Templates" page
        And I expect to see "Template 1"

    Scenario: Template has missing information
        When I press "Adicionar Template"
        Then I expect to be on the "Novo Template" page

        And I fill in "Nome template" with "Template 1"

        When I press "Salvar Template"
        Then I expect to see "O template precisa conter pelo menos uma pergunta"
