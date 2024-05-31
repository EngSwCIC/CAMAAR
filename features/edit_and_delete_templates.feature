Feature: Edit/Delete Template
  As an Administrator
  I want to edit and/or delete a template that I created without affecting already created forms
  So that I can organize the existing templates

  Background: Starting on the templates management page
    Given I am on the Gerenciamento page

  Scenario: Successful edit (happy path)
    When I follow "Editar" within the template list
    And I fill in "Nome do template" with "Novo nome do template"
    And I press "Salvar"
    Then I should be on the Gerenciamento page
    And I should see "Template updated successfully"
    And the already created forms should not be affected

  Scenario: Successful deletion (happy path)
    When I follow "Deletar" within the template list
    And I confirm the deletion
    Then I should be on the Gerenciamento page
    And I should see "template deleted successfully"
    And the already created forms should not be affected

  Scenario: Edit failure due to validation errors (sad path)
    When I follow "Editar" within the template list
    And I fill in "Nome do template" with ""
    And I press "Salvar"
    Then I should be on the edit template page
    And I should see "Preencha os campos obrigatórios"
    And the template should not be updated
