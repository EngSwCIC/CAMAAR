Feature: Sign up Students
  As an Administrator
  I want to sign CIC students up
  In order for them to access the CAMAAR system

Background:
  Given I am on student sign up page

Scenario: Signing up with valid fields (happy path)
  When I enter nome as "nome"
  And I enter curso as "curso"
  And I enter matricula as "123456789"
  And I enter usuario as "usuario"
  And I enter email as "joe@example.com"
  And I click in "sign up"
  Then Login should succeed

Scenario: Signing up with invalid fields (sad path)
  When I enter nome as ""
  And I enter curso as ""
  And I enter matricula as ""
  And I enter usuario as ""
  And I enter email as ""
  And I click in "sign up"
  Then Signing up should fail
