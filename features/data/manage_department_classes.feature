Feature: Manage classes of own department
  As an Administrator
  I want to manage only the classes of the department I belong to
  So that I can evaluate the performance of the classes in the current semester

  Background:
    Given I am logged in as an admin user from the department "Departamento de Ciência da Computação"
    And the current semester is "2026.1"
    And the following classes exist:
      | code      | name                       | department                                    | semester |
      | CIC0097   | Engenharia de Software     | Departamento de Ciência da Computação         | 2026.1   |
      | CIC0124   | Banco de Dados             | Departamento de Ciência da Computação         | 2026.1   |
      | MAT0025   | Cálculo 1                  | Departamento de Matemática                    | 2026.1   |
      | FGA0158   | Estruturas de Dados        | Departamento de Engenharias                   | 2026.1   |

  Scenario: View only classes from own department
    When I navigate to the classes management page
    Then I should see the class "CIC0097 - Engenharia de Software"
    And I should see the class "CIC0124 - Banco de Dados"
    And I should not see the class "MAT0025 - Cálculo 1"
    And I should not see the class "FGA0158 - Estruturas de Dados"

  Scenario: Filter classes by current semester
    When I navigate to the classes management page
    Then I should see only classes from semester "2026.1"
    And each listed class should belong to "Departamento de Ciência da Computação"

  Scenario: View details of a class from own department
    When I navigate to the classes management page
    And I click on the class "CIC0097 - Engenharia de Software"
    Then I should see the details of "CIC0097 - Engenharia de Software"
    And I should see the list of enrolled students
    And I should see the assigned professor

  Scenario: Edit a class from own department
    When I navigate to the classes management page
    And I click on "Edit" for the class "CIC0124 - Banco de Dados"
    And I update the professor to "Profa. Maria Silva"
    And I click on "Save"
    Then I should see a confirmation message "Turma atualizada com sucesso"
    And the class "CIC0124 - Banco de Dados" should have professor "Profa. Maria Silva"

  Scenario: Forbid access to a class from another department
    When I try to access the management page of the class "MAT0025"
    Then I should see an error message "Acesso negado: turma fora do seu departamento"
    And I should be redirected to the classes management page

  Scenario: View empty classes list when department has no classes in current semester
    Given the department "Departamento de Ciência da Computação" has no classes in semester "2026.1"
    When I navigate to the classes management page
    Then I should see a message "Nenhuma turma encontrada para o semestre atual"
