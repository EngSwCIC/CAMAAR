Feature: Department Management System
  As an administrator, I want to manage departments in the system to organize users and resources effectively

Background: I am a logged-in administrator
  Given I am logged in as an administrator

Scenario: Administrator successfully creates a new department (Happy path)
  Given I am on the "Criar Departamento" page
  When I fill in the department details with valid information
  And I click on 'Criar Departamento'
  Then I should see "Departamento criado com sucesso"

Scenario: Administrator tries to create a department with missing information (Sad path)
  Given I am on the "Criar Departamento" page
  When I leave a required field empty
  And I click on 'Criar Departamento'
  Then I should see "Erro, preencha todos os campos obrigatórios"

Scenario: Administrator successfully edits an existing department (Happy path)
  Given I am on the "Editar Departamento" page for "Departamento A"
  When I update the department details with valid information
  And I click on 'Salvar mudanças'
  Then I should see "Departamento atualizado com sucesso"

Scenario: Administrator tries to edit a department with invalid information (Sad path)
  Given I am on the "Editar Departamento" page for "Departamento A"
  When I enter invalid information in a field
  And I click on 'Salvar mudanças'
  Then I should see "Erro, informações inválidas inseridas. Corrija os erros e tente novamente"

Scenario: Administrator successfully deletes a department (Happy path)
  Given I am on the "Lista de departamentos" page
  When I click on the 'Excluir' button for "Departamento B"
  And I confirm the deletion
  Then I should see "Departamento excluído com sucesso"
  And "Departamento B" should no longer be listed

Scenario: Administrator tries to delete a department that does not exist (Sad path)
  Given I am on the "Lista de departamentos" page
  When I click on the 'Excluir' button for a non-existent department
  Then I should see "Erro, departamento não encontrado"

Scenario: Administrator views the list of departments (Happy path)
  Given I am on the "Lista de departamentos" page
  Then I should see a list of departments
  And each department should have options to 'Editar' and 'Excluir'

Scenario: Administrator tries to create a department with a duplicate name (Sad path)
  Given I am on the "Criar Departamento" page
  When I fill in the department name with "Departamento C" which already exists
  And I click on 'Criar Departamento'
  Then I should see "Erro, o nome do departamento já existe. Escolha um nome diferente"
