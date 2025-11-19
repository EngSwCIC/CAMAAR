Feature: Manage classes for admin's department

  Scenario: Admin views and inspects classes from own department
    Given I am admin
    And I am on "gerenciamento/minhas-turmas" page
    And there are classes for my department: "CIC0097 - BANCOS DE DADOS" and "CIC0202 - PROGRAMAÇÃO CONCORRENTE"
    When I view the classes list
    Then I should see "CIC0097 - BANCOS DE DADOS"
    And I should see "CIC0202 - PROGRAMAÇÃO CONCORRENTE"
    When I open the class "CIC0097 - BANCOS DE DADOS"
    Then I should see a performance summary for "CIC0097" for the current semester
    And I can export a CSV of the class performance

  Scenario: Admin attempts direct URL access to a class they do not own
    Given I am admin
    And I am on "gerenciamento/minhas-turmas" page
    And there are classes for my department: "CIC0097 - BANCOS DE DADOS" and "CIC0202 - PROGRAMAÇÃO CONCORRENTE"
    When I navigate directly to "/gerenciamento/minhas-turmas/CIC0105"
    Then I should see an access denied message
    And I should not see "CIC0105 - ENGENHARIA DE SOFTWARE"
    And no CSV file should be downloadable