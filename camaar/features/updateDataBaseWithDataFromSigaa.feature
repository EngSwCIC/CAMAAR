#Eu como Administrador
#Quero atualizar a base de dados já existente com os dados atuais do sigaa
#A fim de corrigir a base de dados do sistema.

Feature: Update database with SIGAA data 

    Background:
        Start from the management page 
        Given I'm admin 
        Then I should see the options menu 

    Scenario: Try to update the database succesfully 
        Given I'm connected to the internet and I'm connected to the database
        When I click on the "Atualizar base de dados"
        Then I should see a message "Base de dados atualizada com os dados atuais do sistema com sucesso"

    Scenario: Try to update the database without a internet connection
        Given I'm not connected to a internet connection
        When I click on "Atualizar base de dados"
        Then I should see a message "Nenhuma conexão com a internet disponível. Nenhum dado foi atualizado."

    Scenario: Try to update the database without a database connection
        Given I'm not connected to a database
        When I click on "Atualizar base de dados"
        Then I should see a message "Nenhuma conexão com base de dados disponível. Nenhum dado foi atualizado."

    Scenario: Try to update the database without having new data locally 
        When I click on "Atualizar base de dados"
        Given there's no new data available 
        Then I should see a message "A base de dados está atualizada"
