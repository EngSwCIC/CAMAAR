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
  if (button_text == "x" || button_text == "X") {
  cy.get(":nth-child(1) > .q-btn > .q-btn__content").click()
  } else {
    cy.contains(button_text).click()
  }
});

And("eu preencher o campo de {string} com {string}", (field_name,name_value) => {
  if (field_name == "title") {
    cy.get(`input.${field_name}`).type(name_value);
  } else if (field_name == "texto" || field_name =="resposta") {
    cy.get(`input.input`).type(name_value);
  }
});

And("eu preencher o campo {string} com {string}", (field_name,name_value) => {
  if (field_name == "Marcador Inicial") {
    cy.get(":nth-child(1) > .container").type(name_value);
  } else if (field_name == "Marcador Final") {
    cy.get(":nth-child(2) > .container").type(name_value);
  } else {
    cy.get(field_name).type(name_value);
  }
});

And("eu selecionar {string}", (component_name) => {
  if (component_name == "1") {
    cy.get("[data-v-3a92c939=\"\"][data-v-c2a21804=\"\"] > :nth-child(1) > :nth-child(1)").select(component_name);
  } else if (component_name == "10") {
    cy.get("[data-v-3a92c939=\"\"][data-v-c2a21804=\"\"] > :nth-child(1) > :nth-child(3)").select(component_name);
  } else {
    cy.get(".selectMenu").select(component_name)
  }
})

Then("eu devo ver o componente de {string}", (component_name)=> {
  if (component_name == "texto") {
    cy.get("textarea.container").should("exist");
  } else if (component_name == "caixa de seleção") {
    cy.get("input.radio").should("exist");
  } else if (component_name == "múltipla escolha") {
    cy.get("input.radio").should("exist");
  } else if (component_name == "escala linear") {
    cy.get("[data-v-3a92c939=\"\"][data-v-c2a21804=\"\"] > :nth-child(1) > :nth-child(1)").should("exist");
  }
});

Then("o título da pergunta deve ser {string}", (title_name) => {
  cy.get(".title").should("have.text", title_name);
});

Then("eu devo ver o campo {string} desabilitado", (field_name) => {
  if (field_name == "texto da resposta") {
    cy.get("textarea.container").should("be.disabled");
  } else if (field_name == "radio" || field_name == "checkbox") {
    cy.get("input.radio").should("be.disabled");
  }
});

Then("o campo de resposta deve ser {string}", (name_value) => {
  cy.get(".input").should("have.text", name_value);
});

Then("eu devo ver {string} linhas", (number_line) => {
  if (number_line == "duas"){
    cy.get("div.container").should("have.length", 2);
  } else if (number_line == "três") {
    cy.get("div.container").should("have.length", 3);
  }
});

Then ("o {string} inicial deve ser {string}", (field_name,value) => {
  if (field_name == "valor") {
    cy.get(":nth-child(1) > .selectValue").should("have.text",value);
  } else if (field_name == "Marcador") {
    cy.get(":nth-child(1) > .container").should("have.text",value);
  }
});

Then ("o {string} final deve ser {string}", (field_name,value) => {
  if (field_name == "valor") {
    cy.get(":nth-child(2) > .selectValue").should("have.text",value);
  } else if (field_name == "Marcador") {
    cy.get(":nth-child(2) > .container").should("have.text",value);
  }
});


