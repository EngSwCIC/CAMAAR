Feature: Create a template form
    As an Administrator
    I want to create a template containing questions
    So that I can generate evaluation forms to assess the performance of the classes


    Background: I am an Coordinator
        Given I am an authenticated Coordinator
        When I follow "Templates"
        Then I should be on the page "Templates"

    Scenario: Coordinator succesfully creates a form template
        When I press the button "add_template"
        Then I should be on the page "Create a New Template"

        And I fill in "template_name" with "Template Teste"
        And I create a multiple choice question "Classifique seu rendimento" with the options "Bom", "Médio", "Ruim"
        And I create a text question "Dê uma sugestão"

        When I press the button "create_template"
        Then I should be on the page "Templates"
        And I should see "Template Teste"