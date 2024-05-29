Feature: Import Data from Database
  As a coordenador I want to import data from the SIGAA database

Background: There is a database with data to import
  Given I am logged in as an administrator
  And there is a source database with updated data
  And I don't have the database yet

Scenario: Successfully import data
  When I access the data import page
  And I click the "Import" button
  Then I should see the message "Importação realizada com sucesso"
  And the data should be updated in the system

Scenario: Import fails due to connection issue
  When I access the data import page
  And I click the "Import" button
  And there is a connection issue with the database
  Then I should see the message "Erro ao conectar com o banco de dados. Tente novamente mais tarde."


