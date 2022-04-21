import { Given, Then, When, And } from "cypress-cucumber-preprocessor/steps";


Given("que eu esteja logado como aluno no CAMAAR", () => {
  expect(true).to.equal(true)
})

And("eu estou na página de relatório do aluno", () => {
  cy.visit("/#/student");
})