Feature: Viewing unanswered forms for enrolled courses
  As a participant of a course
  I want to view the unanswered forms of the courses I am enrolled in
  So that I can choose which one to answer

Background:
    Given I am logged as an User
    And I am on the evaluations webpage

 Scenario: User views the list of unanswered forms and selects one
    When I go to the unanswered forms page
    Then I should see the list of forms
    And when I select a form, I go to the reply page

Scenario: User views when not enrolled in any courses
    Given I am not enrolled in any courses
    When I go to the unanswered forms page
    Then I should see a message "Nenhum formulário para responder"