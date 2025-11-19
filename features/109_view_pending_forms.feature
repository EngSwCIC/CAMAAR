# language: en
Feature: View forms to answer (#109)
  As a Class Participant
  I want to view the unanswered evaluation forms for the classes I am enrolled in
  So that I can choose which one to answer

  Background:
    Given I am signed in as a participant
    And I am enrolled in one or more classes for the current semester

  Scenario: List unanswered forms for my classes
    Given there are evaluation forms assigned to my classes that I have not answered yet
    When I open the page to view my pending forms
    Then I see a list of the unanswered forms for my classes
    And each item shows the class, semester, and form title

  Scenario: Do not show forms I already answered
    Given I have already answered an evaluation form for one of my classes
    When I open the page to view my pending forms
    Then that form is not listed among my pending forms

  Scenario: Empty state when there are no pending forms
    Given there are no unanswered forms for my classes
    When I open the page to view my pending forms
    Then I see a message indicating there are no pending forms
