Feature: Sign up as a Student

    As an User
    I want to set a password for my account from the registration request email
    So that I can access the system


    Background: student has been added to the database
        Given the following student exist:
            | name                   | email            |  course               | registration | education     | occupation |
            | Ana Clara Jordao Perna |acjpjvjp@gmail.com| COMPUTER SCIENCE/CIC | 190084006    | undergraduate | student    |

        Then it should have a valid email  

    Scenario Outline: User has clicked on the registration link
        Given I am an unregistered user 
        And I am on the root page 
        When I press the button "Registrar"
        Then I should be on register page
        And I should see 'Redefina sua Senha'
        When I fill in 'Email' with <email>
        And I press "Confirmar"
        Then I should receive an email 
        And I should see "Registration Link"
        When I click "Registration Link"
        Then I should be on define-password page 
        And I should see 'Olá <name> !'
        And I should see 'Defina sua senha'
        When I fill in 'Senha' with <senha>
        And I fill in 'Confirme sua Senha' with <senha>
        And I press 'Confirmar'
        Then I should be on the page "login"
        And I should see "Bem vindo ao CAMAAR"
        When I fill in "Email" with <email>
        And I fill in "Senha" with <password"
        And I press "Confirmar"
        Then I should be on the page "forms"
        And I should see "<name>"
        And I should see 'Formularios'
    
    Examples:
        | email              | password | name                   |
        | acjpjvjp@gmail.com | 123456   | Ana Clara Jordao Perna |

