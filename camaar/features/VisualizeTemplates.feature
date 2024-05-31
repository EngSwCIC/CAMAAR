#Eu como Administrador
#Quero visualizar os templates criados
#A fim de poder editar e/ou deletar um template que eu criei

Feature: Visualize created templates

        Background: 
            Start from the entry screen 
            Given I click on "Templates"
            Then I should be headed to the "Templates" screen 

        Scenario: No available templates 
            Given there are no created templates
            Then I should see no templates on the screen 

        Scenario: Templates available 
            Given there are any created template
            Then I should see all available templates 

        Scenario: Click on template  
            When I click on a template
            Then I should see a quick menu with options "Deletar", "Editar" and "Visualizar"

        Scenario: Click on "Deletar"
            When I click on a template 
            Given I click on the "Deletar" option in the menu
            Then I should be headed to the deletion screen

        Scenario: Click on "Editar"
            When I click on a template 
            Given I click on the "Editar" option in the menu
            Then I should be headed to the editing screen

        Scenario: Click on "Visualizar"
            When I click on a template 
            Given I click on the "Visualizar" option in the menu
            Then I should be headed to the visualizing screen


        Scenario: Could not fetch templates from database
            Given I'm on the "Templates" screen
            And an error prevents the templates from being fetched from the database
            Then I should see an error "Houve um error ao tentar acessar os templates na base de dados"
