/* eslint-disable no-undef */
import { Given, Then, And, Before } from "cypress-cucumber-preprocessor/steps";
const { get, visit, the, wait, intercept, contains, find, clearLocalStorageCache} = cy;

Before(() => {
  clearLocalStorageCache();
  visit('/');
  the('Email').type('Test');
  the('Senha').type('123');
  the('Login', 'button').click();
});

Given("que eu estou na rota {string}", (page) => {
  cy.visit(`/#${page}`);
});

And(`eu clicar no botão {string}`, (button_text) => {
  cy.contains(button_text).click()
});

And("eu preencher o campo de {string} com {string}", (field_name,name_value) => {
  cy.get(`input.${field_name}`).type(name_value);
});

And("eu preencher o campo {string} com {string}", (field_name,name_value) => {
  cy.get(field_name).type(name_value);
});

Then("eu devo ver o componente de {string}", (component_name)=> {
  if (component_name == "texto") {
    cy.get("textarea.container").should("exist");
  } else if (component_name == "caixa de seleção") {
    cy.get("checkbox").should("exist");
  } else if (component_name == "múltipla escolha") {
    cy.get("radio").should("exist");
  } else if (component_name == "escala linear") {
    cy.contains("Marcador inicial").should("exist");
  }
});

Then("o título da pergunta deve ser {string}", (title_name) => {
  cy.get("questionTitle").should("have.text", title_name);
});

Then("eu devo ver o campo {string} desabilitado", (field_name) => {
  cy.get(field_name).should("be.disable");
});

Then("o campo de resposta deve ser {string}", (name_value) => {
  cy.get("text").should("have.text", name_value);
});

Then("eu devo ver {string} linhas", (number_line) => {
  if (number_line == "duas"){
    cy.get("checkbox").should("have.lengh",2);
  } else if (number_line == "três") {
    cy.get("checkbox").should("have.lengh",3);
  }
});

Then ("o {string} inicial deve ser {string}", (field_name,value) => {
  if (field_name == "valor") {
    cy.get("iniValue").should("have.text",value);
  } else if (field_name == "Marcador") {
    cy.get("answer1").should("have.text",value);
  }
});

Then ("o {string} final deve ser {string}", (field_name,value) => {
  if (field_name == "valor") {
    cy.get("endValue").should("have.text",value);
  } else if (field_name == "Marcador") {
    cy.get("answer1").should("have.text",value);
  }
});


