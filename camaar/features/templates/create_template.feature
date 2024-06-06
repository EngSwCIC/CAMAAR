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

        And I fill in "Template name" with "Template 1"

        When I select "Múltipla escolha" from "opcoes"
        When I select "5" from "escolhas"
        When I press "Adicionar questão"
        Then I expect to see "Questão 1"

        When I fill in the following:
            | question1_title   | Classifique seu rendimento |
            | question1_option1 | Ótimo                      |
            | question1_option2 | Bom                        |
            | question1_option3 | Médio                      |
            | question1_option4 | Ruim                       |
            | question1_option5 | Péssimo                    |

        When I select "Texto" from "opcoes"
        When I press "Adicionar questão"
        Then I expect to see "Questão 2"
        When I fill in the following:
            | question2_title | Dê uma sugestão |

        When I press "Salvar"
        Then I expect to be on the "Templates" page
        And I expect to see "Template 1"

    Scenario: Template has missing information
        When I press "Adicionar Template"
        Then I expect to be on the "Novo Template" page

        And I fill in "Nome template" with "Template 1"

        When I press "Salvar"
        Then I expect to see "O template precisa conter pelo menos uma pergunta"
