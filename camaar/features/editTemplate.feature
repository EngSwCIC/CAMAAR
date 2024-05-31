# Eu como Administrador
# Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
# A fim de organizar os templates existentes

Feature: Edit Template

    Background:
        Start in the Templates page

    Scenario: Successful edit
        When I click on the Edit button on one of the templates
        Then I should see the template information menu
        When I make changes to the fields
        And I click "Salvar"
        Then I should be prompted with "Mudanças salvas!"
        And I should see the Templates page

    Scenario: No changes made
        When I click on the Edit button on one of the templates
        Then I should see template information menu
        When I press "Salvar"
        Then I should see the Templates page

    Scenario: Quit before saving
        When I click on the Edit button on one of the templates
        Then I should see template information menu
        When I press the Close button
        Then I should be prompted with "Mudanças não salvas. Tem certeza que quer sair?"
        When I press "Sim"
        Then I should see the Templates page
    
    Scenario: Cancel quit before saving
        When I click on the Edit button on one of the templates
        Then I should see the template information menu
        When I press the Close button
        Then I should be prompted with "Mudanças não salvas. Tem certeza que quer sair?"
        When I press "Não"
        Then I should see the template information menu