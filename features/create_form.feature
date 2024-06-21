Feature: create a class evaluation form
    As an administrator
    I want to create a form based in a template for the classes I will choose
    So that I can evaluate classes' performances in the current semester

    Background: Starting on the gerenciamento page
        Given a template "Template1" has been created
        And I am on the Gerenciamento page
        When I press "Enviar Formulários"
        Then I should see "Selecione o template"

    Scenario: Sending a form to a class successfully (happy path)
        When I select template "Template1"
        And when I select class "Turma1"
        And I press "Enviar"
        Then I should see "Formulário enviado com sucesso"

    Scenario: Not selecting a template or class (sad path)
        When I press "Enviar"
        Then I should see "Erro: campos não preenchidos"
