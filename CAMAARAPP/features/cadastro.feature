Feature: Cadastro
    As a Aluno
    I want to type my password and click the confirm button
    So that I can have my account created

    Scenario: login
        Given I am on Cadastro page
        And I fill in my password and click the button
        Then My account should be stored in the database
