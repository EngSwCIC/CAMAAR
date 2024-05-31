# Eu como usuario
# Quero definir uma senha para o meu usuario a partir do meu e-mail do sistema de solicitacao de cadastro
# A fim de acessar o sistema

Feature: Set password

    Background:
        Given I'm on the set password page


    Scenario: Fields filled correctly
        When I fill the password textfield with my new password
        And I fill the confirm password textfield with my new password
        And I click on the submit button
        Then I should set my password
        And be on the Login page

    Scenario: Empty password field
        When I fill the confirm password textfield with my new password
        And I click on the submit button
        Then I should be prompted with "Preencha o campo com sua senha."
        And be on the set password page

    Scenario: Empty confirm password field
        When I fill the password textfield with my new password
        And I click on the submit button
        Then I should be prompted with "Confirme sua senha."
        And be on the set password page

    Scenario: Both fields are empty
        When I click on the submit button
        Then I should be prompted with "Preencha os campos necessários"
        And be on the set password page

    Scenario: Confirmation doesn't match password
        When I fill the password textfield with my new password
        And I fill the confirm password textfield with another password
        Then I should be prompted with "Senhas não são iguais"
        And be on the set password page