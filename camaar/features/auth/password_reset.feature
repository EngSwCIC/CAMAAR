Feature: Reset Password

    As an Student or Teacher
    I want to redefine a password for my account from the reset password request email
    So that I can recover access to the system

    Background: User forgot its password and is on login page
        Given that I am a registered User
        And I am on the "Users Login" page
        When I follow "Esqueci minha senha"

    Scenario: User has clicked on the reset password link
        Then I should see "Informe seu email"
        When I fill in "Email" with "student@gmail.com"
        And I press "Confirmar"

        And I received a password reset email at ""
        And I follow "Reset-password Link"
        Then I should be on the "Redefina sua Senha" page
        When I fill in the following:
            | password    | confirmation |
            | newpassword | newpassword  |
        When I press "Confirmar"

        Then I should be on the "Users Login" page
        When I fill in the following:
            | email             | password    |
            | student@gmail.com | newpassword |
        When I press "Confirmar"
        Then I should be on the "Formulários" page
        And I should see "John Doe"

    Scenario: User informed the wrong email
        Then I should see "Informe seu email"
        When I fill in "Email" with "a@gmail.com"
        And I press "Confirmar"
        Then I should see "Usuário não está Registrado"
