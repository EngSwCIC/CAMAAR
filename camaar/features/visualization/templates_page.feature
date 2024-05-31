Feature: View Templates

    As a Coordinator
    I want to view the created templates
    So that I can edit and/or delete a template that I created

    Background:
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        Given that I created the following templates:
            | name       | role    |
            | Template 1 | teacher |
            | Template 2 | student |

        And I am on the "Templates" page

    Scenario: Coordinator views created templates
        Then I should see the following templates:
            | name       | role    |
            | Template 1 | teacher |
            | Template 2 | student |

        Then I should see the button "Deletar" on "Template 1"
        Then I should see the button "Editar" on "Template 1"

        Then I should see the button "Deletar" on "Template 2"
        Then I should see the button "Editar" on "Template 2"




#template_edit.feature
# Scenario: Coordinator Views A Templates Editing Page
#     And I click the "Edit Template" button for "Template 1"
#     Then I should be on the "Template 1" editing page
#     And I should be able to view the editing possibilities.

#template_delete.feature
# Scenario: Coordinator Views Created Templates After Deleting A Template
#     And I click on the "Delete Template" button for "Template 1"
#     Then I should be able to view the created templates
#     But the "Template 1" template should not be there.

#auth feature
# Scenario: Coordinator Logs Out
#     Given I am on "Admin Camaar" page
#     And I click on "Sair"
#     Then I  should be redirected to the "Root" page.