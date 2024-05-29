Feature: Create form for students and teachers
   So that I can evaluate the current semester's classes perfomance
   I want to create a form based on a template for all classes I select 
   As an administrator

Scenario: Create form for a class (Happy path)
   Given I am registered
   And I am an admin
   And I am on the Templates Management page
   And the step I am in is "Enviar Formularios"
   When I press "Enviar Formularios"
   Then I should see "Template:"
   And I should see the class selection table
   When I select "Template teste" from "Template" 
   And I press "Turma teste"
   And I press "Enviar"
   Then I should see "Formulário enviado com sucesso"
   And I should be on the Templates Management page

Scenario: Try sending form without selecting classes (Sad path)
   Given I am registered
   And I am an admin
   And I am on the Templates Management page
   And the step I am in is "Enviar Formularios"
   When I press "Enviar Formularios"
   And I select "Template teste" from "Template" 
   And I press "Enviar"
   Then I should see "Selecione uma turma"
   And I should be on the Templates Management page
   And I should see the class selection table

Scenario: Try sending form without selecting a template (Sad path)
   Given I am registered
   And I am an admin
   And I am on the Templates Management page
   And the step I am in is "Enviar Formularios"
   When I press "Enviar Formularios"
   And I press "Turma teste"
   And I press "Enviar"
   Then I should see "Selecione um template"
   And I should be on the Templates Management page
   And I should see the class selection table

Scenario: Access page withou being registered (Sad path)
   Given I am not registered
   When I am on the Templates Management page
   Then I should see "Você não está cadastrado no sistema"
   And I should be on the sign in page

Scenario: Access page without being an admin (Sad path)
   Given I am registered
   And I am not an admin
   When I am on the Templates Management page
   Then I should see "Você não tem permissão para acessar esta página"
   And I should be on the home page