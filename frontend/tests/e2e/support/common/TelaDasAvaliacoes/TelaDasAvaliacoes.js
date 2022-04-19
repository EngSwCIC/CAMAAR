import { Given, Then, When, And } from "cypress-cucumber-preprocessor/steps";

import axios from 'axios'

let subjects = []

before(() => {
  async function getAllSubjects() {
    await axios.get("http://localhost:3030/subjects/index")
      .then(resp => {
        subjects = resp.data;
      })
      .catch(err => {
          console.error(err);
      });
  }
  getAllSubjects()
})

Given("que eu esteja logado como aluno no CAMAAR", () => {
  // TODO: implementar corretamente depois da issue #9
  cy.visit("/");
  cy.get("[type='email']").type('user')
  cy.get("[type='password']").type('pass')
  cy.contains('Entrar').click()
})

And("eu estou na página de relatório do aluno", () => {
  cy.visit("/#/student");
})

Given("que a turma 'A' da disciplina 'CIC0105' está cadastrada no CAMAAR", () => {
  let subject = subjects.find(subject => subject.code == 'CIC0105')
  console.log(subject)
  assert.notEqual(subject, undefined);
})

When("eu clicar na disciplina 'CIC0105'", () => {
  cy.contains('CIC0105').click()
})

Then("eu deveria ver a turma 'A' e o nome do(a) professor(a) da disciplina 'CIC0105'", () => {
  cy.contains('Turma A').should('be.visible')
})
