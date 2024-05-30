Feature: Generate admin report
  As an administrator, I want to generate reports to analyze feedback

Background: I am a logged-in administrator
  Given I am logged in as an administrator

Scenario: Administrator successfully generates a report
  Given I am on the "Generate Report" page
  When I select the report criteria with valid data
  And I click on 'Generate'
  Then I should see "Relatório gerado com sucesso"

Scenario: The administrator tries to generate a report without selecting a semester
  Given that I am on the "Generate report" page
  When I leave the "Semester" field empty
  And I click 'Generate'
  Then I should see "Erro, preencha o campo semestre para gerar o relatorio"