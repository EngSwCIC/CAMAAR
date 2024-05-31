Feature: Set a new password
  As a user or administrator, I want to set a new password in the system

Background: I am a user that needs to set a password
  Given I've already a log in on the system 

Scenario: User successfully sets a password (Happy path)
  Given I am on the "Definir Senha" page
  When I fill in the password fields with valid information
  And I click on 'Salvar Senha'
  Then I should see "Senha definida com sucesso"

Scenario: User tries to set a new password with missing information (Sad path)
  Given I am on the "Definir Senha" page
  When I leave a password field empty
  And I click on 'Salvar Senha'
  Then I should see "Erro, preencha todos os campos de senha"

Scenario: User tries to set a new password with a weak password (Sad path)
  Given I am on the "Definir Senha" page
  When I fill in the password field with a weak password
  And I click on 'Salvar Senha'
  Then I should see "Erro, a senha é muito fraca. Escolha uma senha mais forte"

Scenario: User tries to set a new password with non-matching passwords (Sad path)
  Given I am on the "Definir Senha" page
  When I fill in the password and confirmation password fields with different values
  And I click on 'Salvar Senha'
  Then I should see "Erro, as senhas não coincidem"

Scenario: User tries to set a new password with an invalid format (Sad path)
  Given I am on the "Definir Senha" page
  When I fill in the password field with an invalid format
  And I click on 'Salvar Senha'
  Then I should see "Erro, a senha inserida não está no formato correto. por favor coloque uma senha válida"
