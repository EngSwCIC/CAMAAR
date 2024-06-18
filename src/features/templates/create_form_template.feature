Feature: Creation of form templates
    As an administrator
    I want to create a form template
    So that I can generate evaluation forms to assess the performance of classes

Background:
    Given I am logged in as an administrator
    And I am on the template creation page
    And I have clicked on the "+" icon
    And I have entered a template name

Scenario: Admin creates a form template with questions
    When I add questions to the template
    And I click on "Criar"
    Then the template should be created
    And I should see a confirmation message "Template criado com sucesso."

Scenario: Admin tries to create a form template without adding questions
    When I click on "Criar"
    Then I should see an error message "Você deve adicionar alguma questão ao template antes de criá-lo."
    And the template should not be created
