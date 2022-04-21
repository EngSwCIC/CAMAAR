import { Given, Then, When, And } from "cypress-cucumber-preprocessor/steps";

import axios from 'axios'

let subjects = []
let classes = []

before(() => {
  async function getAllSubjects() {
    await axios.get("http://localhost:3030/subjects")
      .then(resp => {
        subjects = resp.data;
      })
      .catch(err => {
          console.error(err);
      });
  }
  getAllSubjects()

  async function getAllClasses() {
    await axios.get("http://localhost:3030/cclasses")
      .then(resp => {
        classes = resp.data;
      })
      .catch(err => {
          console.error(err);
      });
  }
  getAllClasses()

})

Given("que eu esteja logado como aluno no CAMAAR", () => {
  // TODO: implementar corretamente depois da issue #9
  cy.visit("/");
  cy.get("[type='email']").type('user')
  cy.get("[type='password']").type('pass')
  cy.contains('Entrar').click()
})

And("eu estou na página de relatório do aluno", () => {
  cy.visit("/#/student-subjects");
})

Given("que a turma 'A' da disciplina 'CIC0105' está cadastrada no CAMAAR", () => {
  let subject = subjects.find(subject => subject.code == 'CIC0105')
  assert.notEqual(subject, undefined);
  let cclass = classes.find(cclass => cclass.subject_id == subject.id)
  assert.notEqual(cclass, undefined);
})

When("eu clicar na disciplina 'CIC0105'", () => {
  cy.contains('CIC0105').click()
})

Then("eu deveria ver a turma 'A'", () => {
  cy.contains('Turma A').should('exist')
})
