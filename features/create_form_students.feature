Feature: Sending forms out to students

  Scenario: Successfully getting to the page
    Given I imported data from SIGAA
    And I am on the Management page
    When I press the "Send Forms" button
    Then I should be on the Send page

  Scenario: Sending out the forms
    Given I am an administrator
    When I send forms

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
