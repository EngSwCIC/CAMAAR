Feature: Sign up as a common user
    As an Student or Teacher
    I want to set a password for my account from the registration request email
    So that I can access the system

    Background: User has been added to the database
        Given that I am an unregistered User
        And I received a registration email at "student2@gmail.com"
        And I follow "Link de cadastro"

    Scenario: User has clicked on the registration link
        Then I should be on the "Cadastro de Usuário" page
        When I fill in the following:
            | email              | password | confirmation |
            | student2@gmail.com | 123456   | 123456       |
        When I press "Confirmar"
        Then I should be on the "Users Login" page
        When I fill in the following:
            | email              | password |
            | student2@gmail.com | 123456   |
        When I press "Confirmar"
        Then I should be on the "Formulários" page
        And I should see "Jane Doe"

    Scenario: User has mismatched the password
        Then I should be on the "Cadastro de Usuário" page
        When I fill in the following:
            | email              | password | confirmation |
            | student2@gmail.com | 123456   | abc123       |
        When I press "Confirmar"
        Then I should see "As senhas não conferem"


