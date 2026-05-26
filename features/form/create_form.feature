Feature: Creating a form from a template

    Background:
        Given I am logged in as an admin user
        And I am on the dashboard page
        And I have created a template with the name "Avaliação Semestral"

    Scenario: Create form for teachers of a class
        When I navigate to the templates page
        And I click on the template named "Avaliação Semestral"
        And I click on "Create Form"
        And I select the class "Engenharia de Software - T01"
        And I choose the target audience "Docentes"
        And I click on "Submit"
        Then I should see a confirmation message "Formulário criado com sucesso"
        And the form should be available for teachers of "Engenharia de Software - T01"

    Scenario: Create form for students of a class
        When I navigate to the templates page
        And I click on the template named "Avaliação Semestral"
        And I click on "Create Form"
        And I select the class "Engenharia de Software - T01"
        And I choose the target audience "Discentes"
        And I click on "Submit"
        Then I should see a confirmation message "Formulário criado com sucesso"
        And the form should be available for students of "Engenharia de Software - T01"

    Scenario: Fail to create form without selecting audience
        When I navigate to the templates page
        And I click on the template named "Avaliação Semestral"
        And I click on "Create Form"
        And I select the class "Engenharia de Software - T01"
        And I click on "Submit"
        Then I should see an error message "Selecione o público-alvo"
