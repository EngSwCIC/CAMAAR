Feature:
    As a Coordinator
    I want to access the system using an email or registration number and a previously set password
    So that I can respond to forms or manage the system

    Scenario: User logs in with valid credentials
        Given that I am a registered User
        And I am on the "Users Login" page
        Then I should see "Bem vindo ao"
        And I should see "CAMAAR"
        When I fill in the following:
            | email    | mholanda@unb.br     |
            | password | professor123        |
        And I press "Confirmar"
        Then I should be on the "User Camaar" page
        And I should see "mholanda@unb.br"
        And I should see "Formulários"


    Scenario: User can't log in with invalid credentials
        Given that I am an unregistered User
        And I am on the "Users Login" page
        Then I should see "Bem vindo ao"
        And I should see "CAMAAR"
        When I fill in the following:
            | email    | noexists@gmail.com |
            | password | 123456         |
        And I press "Confirmar"
        Then I should be on the "Root" page
        # Then I should see "Credenciais Inválidas"


    Scenario: Coordinator logs in with valid credentials
        Given that I am a registered Admin
        And I am on the "Admins Login" page
        Then I should see "Bem vindo ao"
        And I should see "CAMAAR"
        When I fill in the following:
            | email           | admin.dex@gmail.com |
            | password | admin123   |
        And I press "Confirmar"
        Then I should be on the "Admin Camaar" page
        And I should see "admin.dex@gmail.com"
        And I should see "Coordenador"

    Scenario: Coordinator can't log in with invalid credentials
        Given that I am an unregistered Admin
        And I am on the "Admins Login" page
        Then I should see "Bem vindo ao"
        And I should see "CAMAAR"
        When I fill in the following:
            | email          | user@gmail.com |
            | password  | abc123   |
        And I press "Confirmar"
        Then I should be on the "Root" page
        # Then I should see "Credenciais Inválidas"
