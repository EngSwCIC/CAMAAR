Feature: Create a template form
    As an Administrator
    I want to create a template containing questions
    So that I can generate evaluation forms to assess the performance of the classes


    Background: I am an Coordinator
        Given I am an authenticated Coordinator
        When I follow "Templates"
        Then I should be on the route "admin/templates"

    Scenario: Coordinator succesfully creates a form template
        When I press the button "add_template"
        Then I should be on the page "Create a New Template"
        And I fill in "template_name" with "Avaliação Teste"
        Then I should see "Avaliação Teste"

        Then I should see "Questão 1"
        When I select "Múltipla Escolha" from "question_type"
        Then I should see "Texto:"
        And I fill in "text" with "O quão satisfeito você está com a turma?"

        Then I should see "Opção 1:"
        And I fill in "question1_option1" with "Pouco"
        Then I should see "Opção 2:"

        And I fill in "question1_option2" with "Mais ou menos"
        When I press the button "add_option"
        Then I should see "Opção 3:"
        And I fill in "question1_option3" with "Muito"

        When I press the button "add_question"
        Then I should see "Questão 2"
        When I select "Parágrafo" from "question_type"
        Then I should see "Texto:"
        And I fill in "text" with "Dê o seu feedback:"

