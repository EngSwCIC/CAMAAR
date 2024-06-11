Feature: Importing data from SIGAA
    Scenario: Importing for the first time
        Given I am an administrator
        And I am on the main Management page
        And the current semester has no stored data

        When I press "Import data"

        Then I should see how many classes, subjects and students have been added
        And I should be on the main Management page
    
    Scenario: Importing with no changes
        Given I am an administrator
        And I am on the main Management page
        And there have been no changes in the current semester
        
        When I press "Import data"

        Then I should see a toast saying "no changes found"
        And I should be on the main Management page
