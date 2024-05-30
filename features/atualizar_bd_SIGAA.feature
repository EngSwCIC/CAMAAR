Feature: Update database with SIGAA data
  As a coordenador, I want to update the database with data from SIGAA

Background: I am a logged-in coordenador
  Given I am logged in as a coordenador
  And the data has been previously imported

Scenario: Coordenador tries to update the database when SIGAA is out of service
  Given SIGAA is currently out of service
  When I click on 'atualizar turmas'
  Then I should see "Erro, não foi possível concluir a operação"

Scenario: Coordenador successfully updates the database with SIGAA data
  Given SIGAA is available and functioning normally
  When I click on 'atualizar turmas'
  Then I should see "Turmas atualizadas"