Feature: Edit and delete templates without affecting existing forms
  As an Administrator
  I want to edit and/or delete a template I created without affecting already created forms
  In order to organize existing templates

  Scenario: Happy Path - Successfully edit template
    Given that I am on the "Administrator" screen
    And I view the list of registered templates
    When I click the "Edit" button of a specific template
    Then I must be directed to the template editing screen
    And I must see the existing fields filled with current information
    When I modify the desired fields
    And confirm the editing by clicking "Save changes"
    Then the changes must be applied only to the template
    And forms created previously must not be modified
    And I must see a message indicating the template was successfully updated

  Scenario: Happy Path - Successfully delete template
    Given that I am on the "Administrator" screen
    And I view the list of registered templates
    When I click the "Delete" button of a template
    Then I must see a confirmation box asking "Are you sure you want to delete?"
    And I must see a "Yes" button
    And I must see a "No" button
    When I click "Yes"
    Then the selected template must be removed from the list
    And no form created previously using this template must be altered or removed
    And I must see a message indicating the template was successfully deleted

  Scenario: Sad Path - Administrator cancels template deletion attempt
    Given that I am on the "Administrator" screen
    And I view the list of registered templates
    When I click the "Delete" button of a template
    Then I must see the confirmation box for deletion
    When I click the "No" button
    Then I must return to the administrator screen
    And the template must remain in the list