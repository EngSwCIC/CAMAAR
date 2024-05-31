# Eu como Administrador
# Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuarios novos para o sistema
# A fim de que eles acessem o sistema CAMAAR

Feature: Register User

    Background: Start on the Login page
        Given I press the Register button
        Then I should see the Password Change page

    Scenario: Successful Register
        When I fill the Password textfield with my desired password
        And I fill the Confirm Password textfield with my desired password
        And I press the Confirm button
        Then I should be prompted with "Usuário Cadastrado com Sucesso!"
        And I should see the Login Page
    
    Scenario: Password field is empty
        When I fill the Confirm Password textfield with my desired password
        And I press the Confirm button
        Then I should be prompted with "Senhas não são iguais."

    Scenario: Confirm Password field is empty
        When I fill the Password textfield with my desired password
        And I press the Confirm button
        Then I should be prompted with "Senhas não são iguais."

    Scenario: Both fields are empty
        When I press the Confirm button
        Then I should be prompted with "Preencha os campos vazios."