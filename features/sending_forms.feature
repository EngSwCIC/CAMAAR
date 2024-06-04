Feature: Sending forms out to students
    Scenario: Successfully sending out forms
        Given I am an administrator
        And I am seeing the "send forms" popup

        When I select one or more classes
        And I select a template
        And I press "send"
    
        Then I should see a toast saying "sent out to n students"

    Scenario: There are no students in any of the selected classes
        Given I am an administrator
        And I am seeing the "send forms" popup

        When I select one or more classes
        And one of the classes I select has no students
        And I select a template
        And I press "send"
    
        Then I should see a toast saying "one or more of the selected classes has no students"

    Scenario: There are no classes
        Given I am an administrator
        And I am seeing the "send forms" popup
        And there are no classes to select
    
        Then the "send" button should be greyed out and unusable

    Scenario: No templates selected
        Given I am an administrator
        And I am seeing the "send forms" popup
        And I haven't selected a template, either because I didn't want to or there aren't any

        Then the "send" button should be greyed out and unusable
