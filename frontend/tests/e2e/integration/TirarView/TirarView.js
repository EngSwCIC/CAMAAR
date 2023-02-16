import {Given, Then, And} from "cypress-cucumber-preprocessor/steps";

Given("que eu esteja logado como professor ou coordenador no CAMAAR", () => {
  cy.visit("/");
  cy.get("[type='email']").type('user')
  cy.get("[type='password']").type('pass')
  cy.contains('Entrar').click()
})

And("estou na página de relatório do questionário da turma 1", () => {
  cy.visit("/#/student-class/1");
})

Then("sou capaz de ver a coluna 'Aluno' na tabela 'Avaliação dos Estudantes'", () => {
  cy.contains('Avaliação dos Estudantes').should('exist')
  cy.get('.q-table').contains('Aluno').should('exist')
})

Then("não sou capaz de ver a coluna 'Aluno' na tabela 'Avaliação dos Estudantes'", () => {
    cy.contains('Avaliação dos Estudantes').should('exist')
    cy.get('.q-table').contains('Aluno').should('not.exist')
})
