import {Given, Then, And} from "cypress-cucumber-preprocessor/steps";

Given("que eu esteja logado como aluno no CAMAAR", () => {
  // TODO: implementar corretamente depois da issue #9
  cy.visit("/");
  cy.get("[type='email']").type('user')
  cy.get("[type='password']").type('pass')
  cy.contains('Entrar').click()
})

And("eu estou na página de relatório do aluno da turma 1", () => {
  cy.visit("/#/student/1");
})

Then("eu deveria ver o relatório da turma 'A'", () => {
  cy.contains('Média das avaliações').should('exist')
  cy.contains('Avaliação dos Estudantes').should('exist')
})
