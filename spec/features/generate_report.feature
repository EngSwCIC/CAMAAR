Feature: Generating CSV report
    Scenario: Successfully downloading CSV report
        Given I am an administrator
        And I am in the management flow screen
	And There is valid response data for the current class and semester

        When I click the "Results" button
    
        Then I should get a link to a valid results CSV file
        And I should see a toast saying "data downloaded"

    Scenario: Class+Semester has no results
        Given I am an administrator
        And I am in the management flow screen
	And There are no results for the current class and semester 

	Then the "Results" button should be greyed out
