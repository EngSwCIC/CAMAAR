Feature:
    As an User
    I want to access the system using an email or registration number and a previously set password
    So that I can respond to forms or manage the system

    Scenario: User logs in with valid credentials
        Given that I am a registered User
        And I am on the "Users Login" page
        When I fill in the following:
            | email          | password |
            | user@gmail.com | 123456   |
        And I press the button "Entrar"
        Then I should be on the "Formulários" page
        And I should see "John Doe"


    Scenario: User can't log in with invalid credentials
        Given that I am an unregistered User
        And I am on the "Users Login" page
        When I fill in the following:
            | email          | password |
            | user@gmail.com | 123456   |
        And I press the button "Entrar"
        Then I should see "Credenciais Inválidas"


    Scenario: Admin logs in with valid credentials
        Given that I am a registered Admin
        And I am on the "Admins Login" page
        Then I should see "Olá, administrador!"
        When I fill in the following:
            | email           | password |
            | admin@gmail.com | 123456   |
        And I press the button "Login"
        Then I should be on the "Templates" page
        And I should see "Jhon Doe"

    Scenario: Admin can't log in with invalid credentials
        Given that I am an unregistered Admin
        And I am on the "Admins Login" page
        Then I should see "Olá, administrador!"
        When I fill in the following:
            | email          | password |
            | user@gmail.com | abc123   |
        And I press the button "Login"
        Then I should see "Credenciais Inválidas"
