Feature: Sign up Teachers
  As an Administrator
  I want to sign CIC teachers up
  In order for them to access the CAMAAR system

Background:
  Given I am on teacher sign up page

Scenario: Signing up with valid fields (happy path)
  When I enter nome as "nome"
  And I enter departamento as "departamento"
  And I enter formacao as "formacao"
  And I enter usuario as "usuario"
  And I enter email as "joe@example.com"
  And I click in "sign up"
  Then Login should succeed

Scenario: Signing up with invalid fields (sad path)
  When I enter nome as ""
  And I enter departamento as ""
  And I enter formacao as ""
  And I enter usuario as ""
  And I enter email as ""
  And I click in "sign up"
  Then Signing up should fail
