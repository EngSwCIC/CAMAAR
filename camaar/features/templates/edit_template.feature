Feature: Edit a form template
    As an Coordinator
    I want to edit a template without affecting forms that have already been sent
    So that I can organize existing templates effectively

    Background: I am an Coordinator
        Given that there are classes from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        When I follow "Templates"
        Then I should be on the page "Templates"
        Given that I created the template "Template 1"
        Then I should see "Template 1"
        When I press the button "Editar Template"
        Then I should be on the page "Template 1"

    Scenario: Succesfully update a template
        And I fill in "Nome do Template" with "Template 1.1"
        When I press the button "Salvar Template"
        And I confirm a popup
        Then I should be on the page "Templates"
        And I should see "Template 1.1"

    Scenario: Leaves a text field empty
        And I fill in "Nome do Template" with ""
        When I press the button "Salvar Template"
        Then the "Nome do Template" field should have the error "Campo não pode estar vazio"