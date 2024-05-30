#Eu como Administrador
#Quero importar dados de turmas, matérias e participantes do SIGAA (caso não existam na base de dados atual)
#A fim de alimentar a base de dados do sistema.

Feature: Import data from SIGAA
    
    Background:
        Start from the management page
        Given I click on "Importar dados" option in the menu
        Then I should see a screen with a file explorer
    
    Scenario: Select a valid JSON file
        When I select a JSON file 
        Given it's a valid, well structured file 
        Then I should see a screen informing the import was successful and what new data was imported

    Scenario: Select a invalid JSON file 
        When I select a JSON file 
        Given it's a invalid/bad structured file 
        Then I should see a screen error telling me the file is not valid 

        