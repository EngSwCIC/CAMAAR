Scenario: View created templates
  As an Administrator
  I want to visualize the created templates
  So that I can edit and/or delete a created template

  Scenario: At least one template was created (happy path)
    Given I have created a template "Teste"
    And I am on the Templates page
    Then I should see "Teste"

