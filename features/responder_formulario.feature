Feature: Answer an available form
   So that I can submit my evaluation of a class
   I want to answer the form about the class I'm enrolled in
   as a class participant

Scenario: User answers a form successfully (Happy path)
   Given I am registered
   And I am not an admin
   And I am on the forms page
   When I press "Matéria teste"
   Then I should see "Avaliação - Matéria teste - 2024.1"
   When I select "Muito bom" from "Pergunta 1"
   And I fill in "Pergunta 2" with "Texto teste"
   And I press "Enviar avaliação"
   Then I should see "Avaliação enviada com sucesso!"
   And I should be on the forms page

Scenario: User leaves a question blank (Sad path)
   Given I am registered
   And I am not an admin
   And I am on the forms page
   When I press "Matéria teste"
   Then I should see "Avaliação - Matéria teste - 2024.1"
   When I select "Muito bom" from "Pergunta 1"
   And I press "Enviar avaliação"
   Then I should see "Todas as perguntas devem ser respondidas"
   And I should be on the form "1" page

Scenario: User tries to access a form without being registered (Sad path)
   Given I am not registered
   And I am not an admin
   And I am on the forms page
   Then I should see "Você não está cadastrado no sistema."
   And I should be on the login page