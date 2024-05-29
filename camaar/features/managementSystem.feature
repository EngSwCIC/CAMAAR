# Eu como Administrador
# Quero gerenciar somente as turmas do departamento o qual eu pertenço
# A fim de avaliar o desempenho das turmas no semestre atual

Feature: Management System by Department

    Background:
        Start from the management page
        Given I'm an admin

    Scenario: List all classes 
        When I'm on the management page  #Teoricamente isso já tá no background
        Then I should see all classes from my department
    
    # Que tal "When I fill in "Turma" Textfield?
    Scenario: Search a class from my department 
        When I fill in "Turma" with "turma do meu departamento"
        And I click the search button
        Then I should see all classes of "turma do meu departamento" at the current semester 

    # Talvez seja bom separar o inexistent em outro teste?
    Scenario: Search a class from another department or inexistet
        When I fill in "Turma" with "turma de outro departamento"
        And I click the search button
        Then I should see "Turma(s) não encontrada(s)." 

    Scenario: Search a class by professor from my department
        When I fill in "Docente" with "Professor do departamento"
        And I click the search button
        Then I should see all classes that "Professor do departamento" lectures

    Scenario: Search a class by professor from another departamento or inexistet
        When I fill in "Docente" with "Professor de outro departamento"
        And I click the search button 
        Then I should see "Turma(s) não encontrada(s)." 

    Scenario: Search a class by class schedule
        When I fill in "Horário" with a valid class schedule
        And I click the search button
        Then I should see all classes from my department with that class schedule

    Scenario: Search a class by invalid class schedule
        When I fill in "Horário" with an invalid class schedule
        And I click the search button
        Then I should see "Horário inválido"
