Feature: Create evaluation form
  As an Administrator
  I want to create a form based on a template for the classes I choose
  In order to evaluate class performance in the current semester

  Scenario: Happy Path - Successfully create form
    Given that I am on the admin screen
    Then I should see a sidebar menu with a management option
    When I click the management button
    Then I should be redirected to a screen with a create form button
    When I click the create form button
    Then I should be presented with a modal where I must choose the corresponding classes for the form and the template to be used at the end of the modal, there should be a create button
    When I click the create button
    Then the new form should appear alongside the others

  Scenario: Sad Path - Missing required selections
    Given that I am on the admin screen
    Then I should see a sidebar menu with a management option
    When I click the management button
    Then I should be redirected to a screen with a create form button
    When I click the create form button
    Then I should be presented with a modal where I must choose the corresponding classes for the form and the template to be used
    When I try to click the create button without selecting a template
    Then I should see an error message "Please select a template"
    And the form should not be created