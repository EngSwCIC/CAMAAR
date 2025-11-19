Feature: Edit Templates successfully

  Scenario: Edit Templates successfully
    Given I am an admin
    And I am on the "gerenciamento/templates" page
    When I click on "Editar templates" button
    And there are created templates
    Then the edit modal should be displayed
    And I should be able to edit the Templates

  Scenario: Edit Templates unsuccessfully
    Given I am an admin
    And I am on the "gerenciamento/templates" page
    When I click on "Editar templates" button
    And there are no created templates
    Then the "Editar templates" button should be disabled
    And I should not be able to be able to edit the Templates

  Scenario: Delete Templates successfully
    Given I am an admin
    And I am on the "gerenciamento/templates" page
    When I click on "Deletar templates" button
    And there are created templates
    Then the template should be deleted
    And I should see the atualized templates list

  Scenario: Delete Templates unsuccessfully
    Given I am an admin
    And I am on the "gerenciamento/templates" page
    When I click on "Deletar templates" button
    And there are no created templates
    Then the "Editar templates" button should be disabled
    And I should not be able to be able to delete the Templates
