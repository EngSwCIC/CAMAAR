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
        Then I expect to see the following templates:
            | name       | role    |
            | Template 1 | teacher |
            | Template 2 | student |

        Then I expect to see the button "Deletar" on "Template 1"
        Then I expect to see the button "Editar" on "Template 1"

        Then I expect to see the button "Deletar" on "Template 2"
        Then I expect to see the button "Editar" on "Template 2"

    Scenario: Coordinator tries to edit uncreated templates
        Given that I want to edit "Template 3"
        But there is no "Template 3" on "Templates" page
        Then I should not be able to edit it
