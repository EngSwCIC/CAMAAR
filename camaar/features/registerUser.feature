# Como usuário do sistema
# Quero registrar-me no sistema
# A fim de ter acesso às funcionalidades do sistema

Feature: Register User

    Background:
        Start on the Register page

    Scenario: Fields filled correcty
        When I fill the email textField with my email
        And I fill the password textField with my password
        And I click on the register button
        Then I should be on the Login page
    
    Scenario: Email field is empty
        When I fill the password textField with my password
        And I click the register button
        Then I should be prompted with "Preencha o campo de email."
    
    Scenario: Password field is empty
        When I fill the email textField with my email
        And I click the register button
        Then I should be prompted with "Preencha o campo de senha."

    Scenario: Both fields are empty
        When I click the register button
        Then I should be prompted with "Preencha os campos vazios."