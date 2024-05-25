Feature: Create a fo"
        Then I should be on the page "templates/create"
        When I fill in 'Avalie CIC0190'
        And I fill in 'Avalie MAT0023'
        And I fill in 'Avalie ENE0042'rm template


As an Administrator
I want to create a template containing questions
So that I can generate evaluation forms to assess the performance of the classes

    Scenario: View created templates
        Given I am an authenticated "Coordinator"
        And I am on the page home
        When I press the button "templates"
        Then I should be on the page "templates"
        When I follow "add_template
        When I press the button "save"
        #adicionar parte do popup de confirmação
        Then I should be on the page "templates"
        And I should see "newest template"

 
