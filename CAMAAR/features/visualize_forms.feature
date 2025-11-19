Feature: View Forms Admin

    Scenario: View created forms sucessfully
        Given I am an admin
        And I am in "gerenciamento" page
        When I click in "Resultados" button
        Then I should be redirected to "gerenciamento/resultados"
        And I should view the page with created Forms

    Scenario: Tried to view forms without created forms
        Given I am an admin
        And I am in "gerenciamento" page
        And there are not created forms
        When I click on "Resultados" button
        Then the button should not be clickable
