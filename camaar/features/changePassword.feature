# Eu como Usuário
# Quero redefinir uma senha para o meu usuário a partir do e-mail recebido 
# após a solicitação da troca de senha
# A fim de recuperar o meu acesso ao sistema

# Nesse cenário o email já foi mandado então eu acredito que só tem que colocar a nova senha e confirmar ela
# Possivelmente a gente teria que colocar um "Given I'm on the Change Password page" imaginando que essa página 
# só pode ser acessada pelo link do email

Feature: Change password

    Scenario: Try to change password at Login page
        Given I'm a registered user
        And I'm on the Login page
        When I click on the forgot password button
        And I fill in the recovery email textfield with my email
        Then I should receive an email with a link to the change password page

    Scenario: Try to change password of an unregistered user
        Given I'm a user
        And I'm on the Login page
        When I click on the forgot password button
        And I fill in the recovery email textfield with an unregistered email
        Then I should be prompted with "Email não registrado."

    Background:
        Start from the change password page
        Given I'm a registered user

    Scenario: Fields filled correctly
        When I fill in the new password textfield with my new password
        And I fill in the confirm password textfield with my new password
        And click on the change password button
        Then I should change my old password with my new one
        And I should be on Login page

    Scenario: Empty new password field
        When I fill in the confirm password textfield with my new password
        And click on the change password button
        Then I should be prompted with "Preencha o campo com sua senha nova."

    Scenario: Empty confirm password filed
        When I fill in the new password textfield with my new password
        And click on the change password button
        Then I should be prompted with "Confirme sua senha."

    Scenario: Both fields are empty 
        When I click on the change password button
        Then I should be prompted with "Preencha os campos necessários."

    Scenario: New password equal to old password
        When I fill in the new password textfield with my new password
        And it's the same as my current password # interessante essa da senha não poder ser igual a anterior, eu manteria
        And I fill in the confirm password textfield with my new password
        And click on the change password button
        Then I should be prompted with "Sua senha nova não pode ser igual a sua senha atual."

    Scenario: Confirmation doesn't match new password
        When I fill in the new password textfield with my new password
        And I fill in the confirm password textfield with another password
        And click on the change password button
        Then I should be prompted with "Sua senha nova não coincide com a confirmação."
        
