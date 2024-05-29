Feature: Change password

    Background:
        Start from the edit profile page
        Given I'm a registered user

    Scenario: Fields filled correctly
        When I fill in the current password textfield with my current password
        And I fill in the new password textfield with my new password
        And I fill in the confirm password textfield with my new password
        And click on the change password button
        Then I should change my old password with my new one
        And I should be on Login page

    Scenario: Empty current password field
        When I fill in the new password textfield with my new password
        And I fill in the confirm password textfield with my new password
        And click on the change password button
        Then I should be prompted with "Preencha o campo com sua senha atual."

    Scenario: Empty new password field
        When I fill in the current password textfield with my current password
        And I fill in the confirm password textfield with my new password
        And click on the change password button
        Then I should be prompted with "Preencha o campo com sua senha nova."

    Scenario: Empty confirm password filed
        When I fill in the current password textfield with my current password
        And I fill in the new password textfield with my new password
        And click on the change password button
        Then I should be prompted with "Confirme sua senha."

    Scenario: New password equal to old password
        When I fill in the current password textfield with my current password
        And I fill in the new password textfield with my new password
        And they're the same
        And I fill in the confirm password textfield with my new password
        And click on the change password button
        Then I should be prompted with "Sua senha nova não pode ser igual a sua senha atual."

    Scenario: Wrong current password
        When I fill in the current password textfield with the wrong current password
        And I fill in the new password textfield with my new password
        And I fill in the confirm password textfield with my new password
        And click on the change password button
        Then I should be prompted with "Senha inválida."

    Scenario: Confirmation doesn't match new password
        When I fill in the current password textfield with my current password
        And I fill in the new password textfield with my new password
        And I fill in the confirm password textfield with my new password
        And click on the change password button
        Then I should be prompted with "Sua senha nova não coincide com a confirmação."
        
