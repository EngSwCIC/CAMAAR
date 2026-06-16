Feature: Creating a form from a template

    Background:
        Given I am logged in as an admin user
        And I am on the dashboard page
        And a class "CIC0105 - ENGENHARIA DE SOFTWARE (TA - 2021.2)" exists
        And I have created a template with the name Avaliação de Disciplina
        And I have created a template with the name Avaliação de Docente

    Scenario: Create form for teachers of a class
        When I navigate to the forms page
        And I follow "Novo Formulário"
        Then I should see the form creation page
        And I select the class "CIC0105 - ENGENHARIA DE SOFTWARE (TA - 2021.2)"
        And I choose the template "Avaliação de Docente"
        And I click on "Criar Formulário"
        Then I should see a confirmation message "Formulário criado com sucesso."

    Scenario: Create form for evaluation of a class
        When I navigate to the forms page
        And I follow "Novo Formulário"
        Then I should see the form creation page
        And I select the class "CIC0105 - ENGENHARIA DE SOFTWARE (TA - 2021.2)"
        And I choose the template "Avaliação de Disciplina"
        And I click on "Criar Formulário"
        Then I should see a confirmation message "Formulário criado com sucesso."

    Scenario: Fail to create form without selecting audience
        When I navigate to the forms page
        And I follow "Novo Formulário"
        Then I should see the form creation page
        And I choose the template "Avaliação de Disciplina"
        And I click on "Criar Formulário"
        Then I should see an error message "Selecione um template e ao menos uma turma."
