# Eu como Administrador
# Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
# A fim de organizar os templates existentes

Feature: Delete Template

    Background: Start in the Templates page

    Scenario: Successful Deletion
        Given I am in the Templates page
        When I click the trash icon on a template
        Then I should be prompted with "Tem certeza que deseja excluir esse template?"
        When I click "Sim"
        Then I should be prompted with "Template excluído"
        And I should see the Templates page
    
    Scenario: Cancelled Deletion
        Given I am in the Templates page
        When I click the trash icon on a template
        Then I should be prompted with "Tem certeza que deseja excluir esse template?"
        When I click "Não"
        Then I should see the Templates page
