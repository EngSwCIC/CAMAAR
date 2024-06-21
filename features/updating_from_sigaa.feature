Feature: Updating data from SIGAA
    Scenario: Importing with some changes
        Given I am an administrator
        And I am on the main Management page
	And I have imported data for this semester before
        And there have been some changes in the current semester
        
        When I press "Import data"

        Then I should see a toast saying "how many classes, subjects and students have been added"
	And I should be on the main Management page

    Scenario: Importing with no changes
        Given I am an administrator
        And I am on the main Management page
	And I have imported data for this semester before
        And there have been no changes in the current semester
        
        When I press "Import data"

        Then I should see a toast saying "no changes found"
        And I should be on the main Management page
