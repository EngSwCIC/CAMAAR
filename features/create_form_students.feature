Feature: Sending forms out to students

  Scenario: Successfully getting to the page
    Given I imported data from SIGAA
    And I am on the Management page
    When I press the "Send Forms" button
    Then I should be on the Send page

  Scenario: Sending out the forms
    Given I imported data from SIGAA
    When I send forms
    Then the forms should have been sent

  Scenario: No classes selected
    Given I imported data from SIGAA
    When I send forms wihout checking any classes
