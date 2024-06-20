Feature: Import Data from SIGAA
  As an Administrator
  I want to import data for classes, subjects, and participants from SIGAA (if they do not exist in the current database)
  So that I can populate the system's database

  Background: Starting on the data import page
    Given I am on the Gerenciamento page

  Scenario: Successful import (happy path)
    Given I have valid JSONs
    When I press Importar dados
    Then I should be on the Gerenciamento page
    And I should see "Data imported successfully"
    And the classes, subjects, and participants should be added to the database if they do not already exist

  Scenario: Import with existing data (sad path)
    Given there are existing classes, subjects, and participants in the database
    And I have valid JSONs
    When I press Importar dados
    Then I should be on the Gerenciamento page
    And I should see "Não há novos dados para importar"
    And the existing data should not be duplicated

  Scenario: Try to import invalid JSON (sad path)
    Given I don't have valid JSONs
    When I press Importar dados
    Then I should be on the Gerenciamento page
    And I should see "Dados inválidos"