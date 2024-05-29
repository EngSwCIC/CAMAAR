Feature: Export form results

    As a Coordinator
    I want to download a CSV file containing the results of a form
    So that I can evaluate the performance of the classes

    Background: Form has already been answered
    Given I am an authenticated Coordinator
    And I am on the "Resultados" page
    When I click on the download button from a form
    Then I am able to export form's data