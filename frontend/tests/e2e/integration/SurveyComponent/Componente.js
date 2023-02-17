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

Given(`que estou na rota {string}`, (page) => {
  cy.visit(`/#${page}`);
});

And(`eu clicar no botão {string}`, (button_text) => {
  if (button_text == 'adicionar') {
    cy.contains(button_text).click();
  } else if (button_text == "Texto") {
    cy.contains(button_text).click()
  } else if (button_text == "Caixa de seleção") {
    cy.contains(button_text).click()
  }
});

And("eu preencher o campo de {string} com {string}", (field_name,name_value) => {
  cy.get(field_name).type(name_value);
})

Then("eu devo ver o componente de {string}", (component_name)=> {
  if (component_name == "texto") {
    cy.get("textarea").should("exist");
  } else if (component_name == "caixa de seleção") {
    cy.get("checkbox").should("exist");
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
})


