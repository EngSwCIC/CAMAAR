import { Given, Then, And } from "cypress-cucumber-preprocessor/steps";

Given("que eu esteja logado como aluno no CAMAAR", () => {
  cy.visit("/");
  cy.get("[type='email']").type('user')
  cy.get("[type='password']").type('pass')
  cy.contains('Entrar').click()
})

And("eu estou na página de avaliações das turmas", () => {
  cy.visit("/#/reports");
})

Given("que não há questionários cadastrados nesse semestre no sistema", () => {
  cy.contains("2021.2").click();
  cy.contains("2020.1").click();
  cy.contains('Nenhum questionário encontrado').should('be.visible');
})

Given("que há questionários cadastrados nesse semestre no sistema", () => {
  cy.contains("2021.2").should('be.visible');
  cy.contains('Selecione um questionário').should('be.visible');
})

And("selecionei um questionário", () => {
  cy.contains("2021.2").click();
  cy.contains('Selecione um questionário').click();
  cy.contains('Questionário 1').click();
})

Then(/^eu deveria ver uma mensagem na tela dizendo "(.*)"$/, (message) => {
  cy.contains(message).should('be.visible');
})

Then("eu deveria ver um gráfico na tela com as informações do questionário selecionado", () => {
  cy.get('canvas').should('be.visible')
})
