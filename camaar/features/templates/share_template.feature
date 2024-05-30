Feature: Create a form for classes
    As a Coordinator
    I want to create a form based on a template for the classes I choose
    So that I can evaluate the performance of the classes in the current semester

    Background: I am a Coordinator on the templates page
        Given I am an authenticated Coordinator from the "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
        When I follow "Envio"
        Then I should be on the "Envio" page

    Example:
        There are 3 created templates

        | <nome_template_1> |
        | <nome_template_2> |
        | <nome_template_3> |

        There are 2 classes in the current semester

        | Name           | Semester | Code             | Class     |
        | <nome_turma_1> | 2024.1   | <codigo_turma_1> | <turma_1> |
        | <nome_turma_2> | 2024.1   | <codigo_turma_2> | <turma_2> |

    Scenario: Create a form for a class (for teatchers)
        Given I am on the "Envio" page
        When I select the "<nome_template_1>" template in the "Template professores" field
        And I select "<nome_turma_1>" in the classes table
        And I press "Enviar"
        Then I should see "Formulário enviado com sucesso"

    Scenario: Create a form for a class (for students)
        Given I am on the "Envio" page
        When I select the "<nome_template_2>" template in the "Template alunos" field
        And I select "<nome_turma_2>" in the classes table
        And I press "Enviar"
        Then I should see "Formulário enviado com sucesso"

    Scenario: Template not selected
        Given I am on the "Envio" page
        When I select "<nome_turma_1>" in the classes table
        And I press "Enviar"
        Then I should see "Selecione um template"

    Scenario: Class not selected (for teatchers)
        Given I am on the "Envio" page
        When I select the "<nome_template_1>" template in the "Template professores" field
        And I press "Enviar"
        Then I should see "Selecione uma turma"

    Scenario: Class not selected (for students)
        Given I am on the "Envio" page
        When I select the "<nome_template_2>" template in the "Template alunos" field
        And I press "Enviar"
        Then I should see "Selecione uma turma"

    Scenario: Template and class not selected
        Given I am on the "Envio" page
        When I press "Enviar"
        Then I should see "Selecione um template"
        And I should see "Selecione uma turma"

    Scenario: There are no classes in the current semester
        Given I am on the "Envio" page
        Then I should see "Não há turmas disponíveis para envio"