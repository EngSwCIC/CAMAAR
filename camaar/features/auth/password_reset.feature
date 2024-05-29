Feature: Reset Password

    As an User
    I want to redefine a password for my account from the reset password request email 
    In order to to recover my access to the system

    Background: User forgot its password and is on login page
        Given I am an unauthenticated User
        And I am on the "Login de Usuário" page
        When I follow "Esqueci minha senha"
        
    Scenario: User has clicked on the reset password link 
        Then I should see "Informe seu email"
        When I fill in "Email" with "student@gmail.com"
        And I press the button "Confirmar"
        
        Then I should receive an email 
        And I follow "Reset-password Link" #pesquisar como fazer esse passo
        Then I should be on the "Redefina sua senha" page
        When I fill in the following:
            | password    | confirmation |
            | newpassword | newpassword  |
        When I press "Confirmar"
        
        Then I should be on the "Login de Usuário" page
        When I fill in the following:
            | email             | password     |
            | student@gmail.com | newpassword  |
        When I press "Confirmar"
        Then I should be on the page "forms"
        And I should see "John Doe"
    
    Examples:
        | email             | password | confirmation | name     |
        | student@gmail.com | 123456   | 123456       | John Doe |
        | student@gmail.com | 123456   | 123456       | John Doe |
