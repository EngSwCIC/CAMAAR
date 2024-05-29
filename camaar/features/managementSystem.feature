# Eu como Administrador
# Quero gerenciar somente as turmas do departamento o qual eu pertenço
# A fim de avaliar o desempenho das turmas no semestre atual

Feature: Management System by Department

    Background:
        Start from the class management page
        Given I'm an admin
        Then I should see all classes from my department
    
    # Que tal "When I fill in "Turma" Textfield?
    Scenario: Search a class from my department 
        When I fill in "Turma" textfield with "turma do meu departamento"
        And I click the search button
        Then I should see all classes of "turma do meu departamento" at the current semester 


        And I click the search button
        Then I should see "Turma(s) não encontrada(s)." 

    Scenario: Search a class by professor from my department
        When I fill in "Docente" textfield with "Professor do departamento"
        And I click the search button
        Then I should see all classes that "Professor do departamento" lectures

    Scenario: Search a class by professor from another departament
        When I fill in "Docente" textfield with "Professor de outro departamento"
        And I click the search button 
        Then I should see "Turma(s) não encontrada(s)." 

    Scenario: Search a class by inexistet professor 
        When I fill in "Docente" textfield with "Professor inexistente"
        And I click the search button 
        Then I should see "Turma(s) não encontrada(s)." 

    Scenario: Search a class by class schedule
        When I fill in "Horário" textfield with a valid class schedule
        And I click the search button
        Then I should see all classes from my department with that class schedule

    Scenario: Search a class by invalid class schedule
        When I fill in "Horário" textfield with an invalid class schedule
        And I click the search button
        Then I should see "Horário inválido"
