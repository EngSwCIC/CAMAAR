Feature: Submit Form as User

    Scenario: User submits form successfully
        Given I am on the "Avaliações" page
        And there are available forms
        When I click on an available form
        Then I should be redirected to the selected form page

        When I answer all questions in the form
        And I click on the send button
        Then the form should be submitted successfully
        And I should be redirected back to the "Avaliações" page
        And the submitted form should no longer be available

    Scenario: No forms are available for the user
        Given I am on the "Avaliações" page
        And there are no available forms
        Then I should see a message indicating that no forms are available
        And no form items should be displayed

    Scenario: User submits the form without answering all questions
        Given I am viewing an available form
        And I have not answered all mandatory questions
        When I click on the send button
        Then the form should not be submitted
        And I should see a validation error message
        And I should remain on the form page

    Scenario: User tries to submit a form that is no longer available
        Given I am viewing an available form
        And the form has become unavailable
        When I click on the send button
        Then I should see a message that the form is no longer available
        And I should be redirected to the "Avaliações" page
        And the form should not be submitted