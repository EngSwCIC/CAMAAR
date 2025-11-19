Feature: View unanswered forms as teacher

  Scenario: teacher sees list of unanswered forms for their enrolled classes
    Given I am teacher
    And I am on "/meus-formularios" page
    And I am enrolled in "CIC0097 - BANCOS DE DADOS"
    And "CIC0097 - BANCOS DE DADOS" has an unanswered form "Pesquisa de meio de semestre"
    When I view the list of forms
    Then I should see "Pesquisa de meio de semestre" for "CIC0097 - BANCOS DE DADOS"
    And I should see a link "Answer" for "Pesquisa de meio de semestre"

  Scenario: teacher attempts direct URL access to a form they do not have access to
    Given I am teacher
    And I am on "/meus-formularios" page
    And I am enrolled in "CIC0097 - BANCOS DE DADOS"
    When I navigate directly to "/formularios/CIC0105/12345"
    Then I should see an access denied message
    And I should not see the form titled "Final Survey"