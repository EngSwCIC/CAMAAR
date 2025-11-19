Feature: Generate Report as Admin

    Scenario: Admin downloads response reports
        Given I am admin
        And I am on "gerenciamento/resultados" page
        And there are created forms
        When I click on a form
        Then a CSV file containing the form responses should be downloaded

    Scenario: Admin tries to generate a report when no forms exist
        Given I am admin
        When I am on the "gerenciamento/resultados" page
        And there are no created forms
        Then I should see a message indicating that no forms are available
        And no CSV file should be downloaded

    Scenario: Report generation fails due to an internal error
        Given I am admin
        And I am on the "gerenciamento/resultados" page
        And there are created forms
        When I click on a form
        And an internal error occurs during report generation
        Then I should see an error message indicating that the report could not be generated
        And no CSV file should be downloaded

    Scenario: Admin clicks on a form that becomes unavailable
        Given I am admin
        And I am on the "gerenciamento/resultados" page
        And there are created forms
        When I click on a form
        And the form is no longer available
        Then I should see a message indicating that the form cannot be accessed
        And no CSV file should be downloaded