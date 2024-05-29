Feature: Sign up as a Student

    As an User
    I want to set a password for my account from the registration request email
    So that I can access the system


    Background: student has been added to the database
        Given I am the unregistered Student "Jane Doe"
        And I received an registration email
        And I follow the "Link de cadastro"

    Scenario: User has clicked on the registration link 
        Then I should be on the "Cadastro de Usuário" page
        When I fill the following:
            | email              | password | confirmation|
            | student2@gmail.com | 123456   | 123456      |
        When I press "Confirmar"
        Then I should be on the "Login de Usuário"
                When I fill the following:
            | email              | password |
            | student2@gmail.com | 123456   | 
        When I press "Confirmar"
        Then I should be on the "Formulários" page
        And I should see "Jane Doe"
