Feature: Create form template
  As an administrator
  I want to create a form template containing the form questions
  In order to generate evaluation forms to assess class performance

  Scenario: Happy Path - Successfully create template
    Given that I am on the admin screen
    Then I should see a sidebar menu with the management option
    When I click the management button
    Then I should be redirected to a screen with an edit templates button
    When I click the edit templates button
    Then I should be redirected to a screen with all templates and a create new template button
    Then a modal should appear with new template customization options
    When I fill all customization options at the end of the modal, there should be a creation button
    Then as I press the creation button, the new template should be ready for use and appear alongside all others.

  Scenario: Sad Path - Missing required field
    Given that I am on the admin screen
    Then I should see a sidebar menu with the management option
    When I click the management button
    Then I should be redirected to a screen with an edit templates button
    When I click the edit templates button
    Then I should be redirected to a screen with all templates and a create new template button
    Then a modal should appear with new template customization options
    When I fill everything except the template name and click the creation button
    Then I should be presented with a message "the name is a required field" for template creation.