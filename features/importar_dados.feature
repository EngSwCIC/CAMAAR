Feature: Manage SIGAA data import and update
  As an Administrator
  I want to import new data from SIGAA or update existing records
  So that the system's database remains complete and accurate

  Background:
    Given I am logged in as an administrator
    And the SIGAA JSON files for classes, subjects, and participants are available

  Scenario: Successfully import new SIGAA data
    Given the system does not have some of the classes, subjects, or participants from SIGAA
    When I import the SIGAA data into the system
    Then the system should add new classes, subjects, and participants
    And the system should show the message "Dados importados com sucesso"

  Scenario: Successfully update existing records with SIGAA data
    Given the system has outdated information for some classes, subjects, or participants
    When I import the SIGAA data into the system
    Then the system should update the existing records with the latest SIGAA data
    And the system should show the message "Dados importados com sucesso"

  Scenario: Import when all data already exists and is up to date
    Given all SIGAA data already exists and is current in the system
    When I import the SIGAA data into the system
    Then the system should skip all existing records
    And the system should show the message "Não há novos dados"

  Scenario: SIGAA file is missing or invalid
    Given I attempt to import a missing or corrupted JSON file
    When I press "Importar dados"
    Then I should see the error message "Arquivo inválido ou não encontrado"