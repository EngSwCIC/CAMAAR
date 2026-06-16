Feature: Updating the database with current SIGAA data

    Background:
        Given I am logged in as an admin user
        And I am on the dashboard page

    Scenario: Successfully import current SIGAA data
        Given a valid SIGAA data file is available
        When I follow "Importar Novos Usuários"
        And I upload the SIGAA data file
        And I click on "Update Database"
        Then I should see a confirmation message "Base de dados atualizada com sucesso"
        And the system data should reflect the new SIGAA information

    Scenario: Update preserves existing forms and templates
        Given I have created a template with the name "Template Existente"
        And I have created a form called "Formulário Existente"
        And a valid SIGAA data file is available
        When I follow "Importar Novos Usuários"
        And I upload the SIGAA data file
        And I click on "Update Database"
        Then I should see a confirmation message "Base de dados atualizada com sucesso"
        And the template "Template Existente" should still exist
        And the form "Formulário Existente" should still exist

    Scenario: Fail to update with invalid SIGAA file
        Given an invalid SIGAA data file is available
        When I follow "Importar Novos Usuários"
        And I upload the SIGAA data file
        And I click on "Update Database"
        Then I should see an error message "Arquivo SIGAA inválido"
        And the database should remain unchanged
