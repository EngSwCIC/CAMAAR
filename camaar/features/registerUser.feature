# Eu como Administrador
# Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuarios novos para o sistema
# A fim de que eles acessem o sistema CAMAAR

Feature: Register User

    Background: Start on the Gerenciamento page
        Given I am an administrator

    Scenario: Successful Import
        When I press the Importar Dados button
        Then I should see the Turmas page
        And I should see a file selection page
        When I select a JSON file with the desired class
        Then I should see the class code in the Turmas page
        When I press the Enviar button
        Then I should see the Gerenciamento page

    Scenario: JSON file is empty/corrupted
        When I press the Importar Dados button
        Then I should see the Turmas page
        And I should see a file selection page
        When I select an empty/corrupted JSON file
        Then I should be prompted with "Arquivo Inválido."
        And I should see the Gerenciamento page

    Scenario: Invalid emails in JSON file
        When I press the Importar Dados button
        Then I should see the Turmas page
        And I should see a file selection page
        When I select a JSON file with one or more invalid emails
        Then I should be prompted with "Emails inválidos no arquivo"
        And I should see the Gerenciamento page   

        