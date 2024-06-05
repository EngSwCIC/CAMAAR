Feature: Create form template
  As a coordenador, I want to create form templates for reuse

Background: I am a logged-in coordenador
  Given I am logged in as a coordenador

Scenario: coordenador successfully creates a new form template
  Given I am on the "Create Form Template" page
  When I fill in the template details with valid information
  And I click on 'Save'
  Then I should see "Template criado com sucesso"

Scenario: coordenador tries to create a form template without a name
  Given I am on the "Create Form Template" page
  When I leave the "Name" field empty
  And I click on 'Save'
  Then I should see "Erro, preencha o nome"

Scenario: The coordenador tries to create a template without linked questions
  Given that I am on the "Create Form Template" page
  When I create a template without at least one question
  And I click 'Save'
  Then I should see "Erro, o template não possui perguntas vinculadas"

Scenario: coordenador tries to create a form template with a duplicate name
  Given a form template with the name "EngSoftware-1-2024" already exists
  And I am on the "Create Form Template" page
  When I enter "EngSoftware-1-2024" as the name
  And I click on 'Save'
  Then I should see "Erro, já existe um template com o nome inserido"