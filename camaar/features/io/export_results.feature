Feature: Export form results

    As a Coordinator
    I want to download a CSV file containing the results of a form
    So that I can evaluate the performance of the classes

    Background: Form has already been answered

        Given that a form assigned to the students of the following classes were answered:
            | subject | semester | code |
            | CIC0097 | 2021.2   | TA   |
        Given that a form has been assigned to the teachers of the following classes:
            | subject | semester | code |
            | CIC0097 | 2021.2   | TA   |
            
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        When I follow "Resultados"
        
        Then I expect to see "Formulário Aluno"
        Then I expect to see "Formulário Professor"


    Scenario: Export the responses of a answered form
        When I press "export csv 1"
        Then I expect to see a download window with the file "1_Formulário_Aluno.csv"

    Scenario: Generate a report from the responses of a answered form
        When I press "export graph 1"
        Then I expect to see a download window with the file "1_Formulário_Aluno.png"

    Scenario: Tries to export graph of a with no responses
        When I press "export graph 2"
        Then I expect to see "O formulário não possui respostas"