# Como usuário do sistema
# Quero preencher os campos de um formulário disponível 
# A fim de enviá-lo para o sistema

Feature: Answer Form

    Background:
        Given I'm in a form page

    Scenario: Fields filled correctly
        When I provide answers for all questions
        And I click on the Send button
        Then I should be prompted with "Formulário Respondido Com Sucesso!"
        And I should be on the Home page

    Scenario: Missing fields
        When I provide answers for most questions
        And I leave one or more answer fields empty
        And I click on the Send button
        Then I should be prompted with "Há campos não preenchidos."