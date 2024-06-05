Feature: Register new user
  As an coordenador, I want to register new users in the system

Background: I am a logged-in administrator
And I am on the "Cadastrar Usuários" page

When I select the imported users
And I click on 'Cadastrar'
Then I should see "Usuários cadastrados com sucesso"
And I should see the list of registered users


When I try to register users with missing information
And I click on 'Cadastrar'
Then I should see "Erro, alguns dados estão faltando. Por favor, verifique e tente novamente"

When I try to register users with invalid email addresses
And I click on 'Cadastrar'
Then I should see "Erro, alguns emails são inválidos. Por favor, corrija os emails e tente novamente"


When I try to register users with invalid email addresses
And I click on 'Cadastrar'
Then I should see "Erro, alguns emails são inválidos. Por favor, corrija os emails e tente novamente"


When I try to register users with invalid registrations
And I click on 'Cadastrar'
Then I should see "Erro, algumas matrículas são inválidas. Por favor, corrija as matrículas e tente novamente"
