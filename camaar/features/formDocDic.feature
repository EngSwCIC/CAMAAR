# Eu como Administrador
# Quero escolher criar um formulário para os docentes ou os dicentes de uma turma
# A fim de avaliar o desempenho de uma matéria

Feature: Create a form for professors or students

    Background:
        Start from the management page
        Given I'm an admin 

    Scenario: Create a student form
        When I click create student form button 
        And I fill in the class textfild with "turma"
        And I fill in the form's contents
        Then I should create a form for students of that class 

    Scenario: Create a professor form
        When I click create professor form button 
        And I fill in the class textfild with the "turma"
        And I fill in the form's contents
        Then I should create a form for professors of that class 

    Scenario: Create a student form for an inexistent class 
        When I click create student form button
        And I fill in the class textfild with "turma inexistente"
        And I fill in the form's contents
        Then I should see "Turma inexistente."

    Scenario: Create a professor form for an inexistent class 
        When I click create professor form button
        And I fill in the class textfild with "turma inexistente"
        And I fill in the form's contents
        Then I should see "Turma inexistente."

    Scenario: Create an empty student form 
        When I click create student form button 
        And I fill in the class textfild with "turma"
        Then I should see "Preencha o(s) conteúdo(s) do formulário."

    Scenario: Create an empty professor form 
        When I click create professor form button 
        And I fill in the class textfild with "turma"
        Then I should see "Preencha o(s) conteúdo(s) do formulário."