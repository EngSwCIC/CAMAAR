Feature: Visualize Templates

    Scenario: Visualize Templates successfully
        Given I am an admin
        And I am on the "gerenciamento" page
        When I click on "Editar templates" button
        And there are created templates
        Then I should be redirected to "gerenciamento/templates"
        And I should see the templates list

    Scenario: Visualize Templates unsuccessfully
        Given I am an admin
        And I am on the "gerenciamento" page
        When I click on "Editar templates" button
        And there are no created templates
        Then the "Editar templates" button should be disabled
