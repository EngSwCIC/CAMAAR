Feature: Redefine password from email link
  As a User
  I want to redefine my password from the email received after requesting a password change
  So that I can recover my access to the system

  Background:
    Given I have a registered account with the email "usuario@unb.br"
    And I have requested a password reset for "usuario@unb.br"
    And I have received the reset link in my email

  Scenario: Redefine password successfully from email link
    When I access the reset link from my email
    And I fill in the new password field with "NovaSenha123"
    And I fill in the confirmation field with "NovaSenha123"
    And I click on "Reset Password"
    Then I should see a confirmation message "Senha redefinida com sucesso"
    And I should be redirected to the login page
    And I should be able to log in with "usuario@unb.br" and "NovaSenha123"

  Scenario: Fail to redefine password with mismatched confirmation
    When I access the reset link from my email
    And I fill in the new password field with "NovaSenha123"
    And I fill in the confirmation field with "OutraSenha456"
    And I click on "Reset Password"
    Then I should see an error message "As senhas não coincidem"
    And my password should remain unchanged

  Scenario: Fail to redefine password with weak password
    When I access the reset link from my email
    And I fill in the new password field with "123"
    And I fill in the confirmation field with "123"
    And I click on "Reset Password"
    Then I should see an error message "Senha não atende aos requisitos mínimos"

  Scenario: Fail to use an expired reset link
    Given the reset link has expired
    When I access the reset link from my email
    Then I should see an error message "Link de redefinição expirado"
    And I should see an option to "Request new link"

  Scenario: Fail to reuse an already-used reset link
    Given I have already redefined my password using the reset link
    When I access the reset link from my email again
    Then I should see an error message "Link de redefinição inválido ou já utilizado"
