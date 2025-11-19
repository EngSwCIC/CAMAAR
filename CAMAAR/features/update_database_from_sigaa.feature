Feature: Update database from SIGAA

  Scenario: Admin updates local database with current SIGAA data
    Given I am admin
    And I am on "/gerenciamento/atualizar-base" page
    And the SIGAA credentials are valid
    And SIGAA contains the latest data for departments, classes and users
    When I click "Update from SIGAA"
    Then I should see a confirmation "Database updated successfully"
    And the system data should reflect the SIGAA records

  Scenario: Admin attempts update but SIGAA is unavailable or credentials are invalid
    Given I am admin
    And I am on "/gerenciamento/atualizar-base" page
    And the SIGAA credentials are invalid or SIGAA is unreachable
    When I click "Update from SIGAA"
    Then I should see an error message "Could not update database from SIGAA"
    And no changes should be applied to the system database