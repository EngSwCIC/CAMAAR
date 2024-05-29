Feature: Visualize forms available to answer
   So that I can choose which form to answer
   I want to visualize the non-answered forms of classes I'm enrolled in
   as a class participant

Scenario: Visualize available forms (Happy path)
   Given I am registered
   And I am not an admin
   And I am on the forms page
   Then I should see "Matéria teste"

Scenario: Not see forms that I have already answered (Happy path)
   Given I am registered
   And I am not an admin
   And I am on the forms page
   And I have answered the form "Matéria teste"
   Then I should not see "Matéria teste"

Scenario: User is not registered (Sad path)
   And I am on the forms page
   Given I am not registered
   Then I should see "Você não está cadastrado no sistema."
   And I should be on the login page

Scenario: User connection timed out (Sad path)
   Given I am registered
   And I am not an admin
   And I am on the forms page
   And my connection with the server timed out
   Then I should see "Falha ao carregar formulários. Verifique sua conexão e tente novamente."

