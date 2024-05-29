Feature: Sign up as a Student
    As an User
    I want to set a password for my account from the registration request email
    So that I can access the system

    Background: student has been added to the database
        Given that I am an unregistered User
        And I received an registration email at ""
        And I follow "Link de cadastro"

    Scenario: User has clicked on the registration link
        Then I should be on the "Cadastro de Usuário" page
        When I fill in the following:
            | email              | password | confirmation |
            | student2@gmail.com | 123456   | 123456       |
        When I press the button "Confirmar"
        Then I should be on the "Login de Usuário" page
        When I fill in the following:
            | email              | password |
            | student2@gmail.com | 123456   |
        When I press the button "Confirmar"
        Then I should be on the "Formulários" page
        And I should see "Jane Doe"
