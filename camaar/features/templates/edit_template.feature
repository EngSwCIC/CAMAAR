Feature: Edit a form template
    As an Coordinator
    I want to edit a template without affecting forms that have already been sent
    So that I can organize existing templates effectively

    Background: I am an Coordinator
        Given that I imported classes for the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        When I follow "Templates"
        Then I should be on the "Templates" page
        Given that I created the following templates:
            | Template 1 | teacher |
        Then I should see "Template 1"
        When I press the button "Editar Template"
        Then I should be on the "Template 1" page

    Scenario: Succesfully update a template
        And I fill in "Nome do Template" with "Template 1.1"
        When I press the button "Salvar Template"
        And I confirm a popup
        Then I should be on the "Templates" page
        And I should see "Template 1.1"

    Scenario: Leaves a text field empty
        And I fill in "Nome do Template" with ""
        When I press the button "Salvar Template"
        Then the "Nome do Template" field should have the error "Campo não pode estar vazio"
