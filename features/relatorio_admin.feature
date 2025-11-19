Feature: Export Form Results to CSV
    As an Administrator
    I want to download a CSV file containing form results
    In order to evaluate class performance

    Background:
        Given that I am logged in as an administrator

    Scenario: Successfully download CSV file with form results
        Given that I am on the form results page
        And there are form results available
        When I click on "Download CSV"
        Then a CSV file should be downloaded
        And the file should be named "form_results.csv"
        And the CSV file should contain form result data

    Scenario: Download CSV when no form results are available
        Given that I am on the form results page
        And there are no form results available
        When I click on "Download CSV"
        Then I should see "No form results available for export"
        And no file should be downloaded