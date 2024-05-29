Feature: Edit existing form template
   In order to organize the already existing form templates
   As an administrator
   I want to edit and/or delete an existing template without modifying the other forms

Scenario: Edit a template to have radio type question (Happy path)
   Given I am registered
   And I am an admin
   And I am on the Templates Management page
   And the step I am in is "Editar Formularios"
   And I have an existing template named "Template"
   When I press "Editar template"
   And I fill in "Nome do template" with "Template para teste"
   And I select "Radio" from "Tipo"
   And I fill in "Texto" with "Descrição da questão para teste"
   And I fill in "Opcao-1" with "Opção da questão para teste"
   And I press "Salvar"
   Then I should be on the Templates Management page
   And I should see "Template atualizado com sucesso!"
   And I should see "Template para teste"
   When I press "Template para teste"
   Then I should see "Descrição da questão para teste"
   And I should see "Opção da questão para teste"

Scenario: Edit a template that has a radio type question to have an extra option (Happy path)
   Given I am registered
   And I am an admin
   And I am on the Templates Management page
   And the step I am in is "Editar Formularios"
   And I have an existing template named "Template"
   When I press "Editar template"
   And I press "Adicionar opção"
   And I fill in "Opcao-2" with "Opção da questão para teste 2"
   And I press "Salvar"
   Then I should be on the Templates Management page
   And I should see "Template atualizado com sucesso!"
   And I should see "Template para teste"
   When I press "Template para teste"
   Then I should see "Descrição da questão para teste"
   And I should see "Opção da questão para teste"
   And I should see "Opção da questão para teste 2"

Scenario: Edit a template to have text type question (Happy path)
   Given I am registered
   And I am an admin
   And I am on the Templates Management page
   And the step I am in is "Editar Formularios"
   And I have an existing template named "Template"
   When I press "Editar template"
   And I fill in "Nome do template" with "Template para teste"
   And I select "Text" from "Tipo"
   And I fill in "Texto" with "Descrição da questão para teste"
   And I press "Salvar"
   Then I should be on the Templates Management page
   And I should see "Template atualizado com sucesso!"
   And I should see "Template para teste"
   When I press "Template para teste"
   Then I should see "Descrição da questão para teste"

Scenario: Delete a template sucessfully (Happy path)
   Given I am an admin
   And I am on the Templates Management page
   And the step I am in is "Editar Formularios"
   And I have an existing template named "Template"
   When I press "Deletar template"
   Then I should see "Você tem certeza de que deseja deletar este template?"
   And I should see "Essa ação é irreversível"
   When I press "Sim"
   Then I should see "Template deletado com sucesso"
   And I should be on the Templates Management page
   And I should not see "Template de teste"

Scenario: Regreted deleting a template (Happy path)
   Given I am an admin
   And I am on the Templates Management page
   And the step I am in is "Editar Formularios"
   And I have an existing template named "Template"
   And I should see "Template de teste"
   When I press "Deletar template"
   Then I should see "Você tem certeza de que deseja deletar este template?"
   And I should see "Essa ação é irreversível"
   When I press "Não"
   And I should be on the Templates Management page
   And I should see "Template de teste"

Scenario: Visit management page without being the admin (Sad path)
   Given I am on the Templates Management page
   Given I am registered
   And I am not an admin
   Then I should see "Você não tem permissão para acessar esta página."	
   And I should be on the home page

Scenario: Visit management page without being registered (Sad path)
   Given I am on the Templates Management page
   Given I am not registered
   Then I should see "Você não está cadastrado no sistema."
   And I should be on the sign in page