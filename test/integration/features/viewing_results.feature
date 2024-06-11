Feature: Viewing Results
    Scenario: There are results to be seen
        Given I am an administrator
        And I am on the main Management page
        And there are results for the current semester

        When I press "Results"

        Then I should be redirected to the Results page
        And I should see at least one card

    Scenario: There are no results to be seen
        Given I am an administrator
        And I am on the main Management page
        And there are no results for the current semester

        When I press "Results"

        Then I should be redirected to the Results page
        And There should be no visible cards 

    Scenario: Clicking a card
        Given I am an administrator
        And I am on the Results page
        And there are visible result cards

        When I open any card

        Then I should be redirected to a read-only view of the filled-in template
