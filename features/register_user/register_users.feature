Feature: Register system users
  As an administrator of the CAMAAR system
  I want to register new users (teachers or students)
  So that they can have access to the platform

  Background:
    Given I am logged in as the "Administrador" profile
    And I am on the user registration page

  Scenario: [Happy Path] Register user with valid data
    When I fill the "Nome" field with "João da Silva"
    And I fill the "Matrícula" field with "200012345"
    And I fill the "Email" field with "joao.silva@unb.br"
    And I select the "Discente" profile
    And I click the "Save User" button
    Then the system should register the new user
    And I should see the green message "Usuário cadastrado com sucesso."

  Scenario: [Sad Path] Register with already existing email
    Given a user already exists with email "joao.silva@unb.br"
    When I fill the "Nome" field with "João da Silva"
    And I fill the "Matrícula" field with "200012345"
    And I fill the "Email" field with "joao.silva@unb.br"
    And I select the "Discente" profile
    And I click the "Save User" button
    Then the system should not register the user
    And I should see the error message "Este email já está em uso por outro usuário."
