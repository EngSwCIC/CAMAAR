Feature: Viewing Results

  Scenario: There are results to be seen
    Given I imported data from SIGAA
    When I move to the Evaluations page
    Then I should see at least one result card

  Scenario: There are no results to be seen
    Given I am an administrator
    When I move to the Evaluations page
    Then I should not see any result cards
