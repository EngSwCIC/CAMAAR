Feature: Viewing Templates
    Scenario: There are templates to be seen
        Given I am an administrator
        And I am on the main Management page
        And there are templates for the current semester

        When I press "edit templates""

        Then I should be redirected to the Templates page
        And I should see at least one card

    Scenario: There are no templates to be seen
        Given I am an administrator
        And I am on the main Management page
        And there are no templates for the current semester

        When I press "Templates"

        Then I should be redirected to the Templates page
        And There should be no visible cards

    Scenario: Clicking a card
        Given I am an administrator
        And I am on the Templates page
        And there are visible result cards

        When I open any card

        Then I should be redirected to a view of the filled-in template
