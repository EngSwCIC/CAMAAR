Feature: Reset Password

    As an Student or Teacher
    I want to redefine a password for my account from the reset password request email
    So that I can recover access to the system

    Background: User forgot its password and is on login page
        Given that I am a registered User
        And there are no emails
        And I am on the "Users Login" page
        When I follow "Esqueceu a senha?"

    Scenario: User has clicked on the reset password link
        Given I have no emails at "mholanda@unb.br"
        Then I expect to see "Insira seu email para redefinição"
        When I fill in "Email" with "mholanda@unb.br"
        And I click on "Confirmar"
        And I received a Reset password instructions email at "mholanda@unb.br"
        And I follow "Mudar minha Senha" at "mholanda@unb.br"
        Then I expect to be on the "Redefinir Senha Usuario" page
        When I fill in the following:
            | password  | professor123 |
            | password2 | professor123 |
        When I click on "Confirmar"

        Then I expect to be on the "Users Login" page
        When I fill in the following:
            | email    | mholanda@unb.br |
            | password | professor123    |
        When I click on "Confirmar"
        Then I expect to be on the "User Camaar" page
        And I expect to see "Maristela"
        And I expect to see "Docente"
        And I expect to see "CIC"
        And I expect to see "Formulários"

    Scenario: User informed the wrong email
        Then I expect to see "Insira seu email para redefinição"
        When I fill in "Email" with "notregistered@gmail.com"
        And I click on "Confirmar"
# Then I expect to see "Usuário não está Registrado"