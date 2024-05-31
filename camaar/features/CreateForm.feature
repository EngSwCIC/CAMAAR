#Eu como Administrador
#Quero criar um formulário baseado em um template para as turmas que eu escolher
#A fim de avaliar o desempenho das turmas no semestre atual

Feature: create a form
    
    Scenario: Avaliable templates
        Given I am an admin
        And I have avaliable templates to choose from
        And I have classes to assign the form to
        When I choose a template
        And I type the title of all questions
        And I type the alternatives of all questions
        And I click on the submit button
        Then I should be able to create a form

    Scenario: No templates avaliable
        Given I am an admin
        And I don not have avaliable templates to choose from
        Then I should not be able to create a form

    Scenario: No classes avaliable
        Given I am an admin
        And I have avaliable templates to choose from
        But I have no classes to assign the form to
        Then I should not be able to create a form

    Scenario: empty title
        Given I am an admin
        And I have avaliable templates to choose from
        And I have classes to assign the form to
        When I choose a template
        But I do not type the title of of one or more questions
        And I type the alternatives of all questions
        And I click on the submit button
        Then I should be prompted with "Preencha todos os campos"

    Scenario: empty alternatives
        Given I am an admin
        And I have avaliable templates to choose from
        And I have classes to assign the form to
        When I choose a template
        And I type the title of all questions
        But I do not type the alternatives of one or more questions
        And I click on the submit button
        Then I should be prompted with "Preencha todos os campos"