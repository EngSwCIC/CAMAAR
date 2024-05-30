Feature: Login System
  As a system user
  I want to access the system using an e-mail or enrollment number and a registered password
  So that I can answer forms or manage the system

  Background: Starting on the login page
    Given I am on the login page

  Scenario: Correct Information (happy path)
    When I fill in the login page with "teste@email.com" as an e-mail and "123456" as a password
    Then I should be on the Avaliacoes page