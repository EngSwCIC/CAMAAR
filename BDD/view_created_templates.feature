Feature: View created templates
  As an Administrator
  I want to view the created templates
  In order to edit and/or delete a template I created

  Scenario: Happy Path - Edit template
    Given that I am on the "Administrator" screen
    Then I should see all "Templates"
    And I should see an "Edit" button for each "Template"
    And I should see another button for "Delete"
    When I click the "Edit" button
    Then I should see the template screen with fields for modification

  Scenario: Sad Path - Cancel template deletion
    Given that I am on the "Administrator" screen
    Then I should see all "Templates"
    And I should see an "Edit" button for each "Template"
    And I should see another button for "Delete"
    When I click the "Delete" button
    Then I should see a box with the text "Are you sure you want to delete?"
    And I should see a button labeled "Yes"
    And I should see another button labeled "No"
    When I click the "No" button
    Then I return to the Administrator Screen
    And the template is still there