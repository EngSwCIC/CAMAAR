#Eu como Administrador
#Quero criar um template de formulário contendo as questões do formulário
#A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

Feature: create template
    
    Scenario: create a template
        Given I am an admin
        When i click on the create template button
        And I add the number of questions
        And I select the question format type of all questions
        When I click on the create button
        Then I should be able to create a template

    Scenario: No type selected
        Given I am an admin
        When i click on the create template button
        And I add the number of questions
        But I do not select the question format type of one or more questions
        When I click on the create button
        Then I should be prompted with the "Selecione o tipo de todas as questões"

#Esse cenário está considerando que é possível criar um template vazio, caso seja do interesse do admin
    Scenario: Empty template
         Given I am an admin
         When i click on the create template button
         And all fields are empty
         Then I should be able to create a template
        
