/* eslint-disable no-undef */
import {
  Given,
  Then,
  And,
  Before,
  After,
} from "cypress-cucumber-preprocessor/steps";
import axios from "axios";
const { visit, the, wait, location, intercept, clearLocalStorageCache } = cy;

Before(() => {
  clearLocalStorageCache();
});
after(async () => {
  let req = await axios.put("/api/auth", {
    user: {
      email: "peluticaio@gmail.com",
      current_password: "12345",
      password: "1234",
      password_confirmation: "1234",
    },
  });
});
Given(`que estou na rota {string}`, (pagina) => {
  visit(pagina);
});
Given(`que estou na pagina de redefinicao de senha`, () => {
  visit("http://localhost:8080/#/cadastrar/abcde");
});
Given(`que cliquei no {string}`, (id) => {
  the(id).click();
});
Given(`que nao estou autenticado`, () => {
  cy.clearLocalStorageCache();
});
Given(`que o campo email não foi preenchido`, () => {
  cy.get("form").within(() => {
    cy.get('[data-test-email="email"]').should("have.value", "");
  });
});
Given(`que o campo senha não foi preenchido`, () => {
  cy.get("form").within(() => {
    cy.get('[data-test-senha="senha"]').should("have.value", "");
  });
});
Then(/^(:?|eu )deveria ver [o|a] (\w+)$/, (a, id) => {
  the(id);
});
Then("eu deveria ver uma mensagem {string}", (msg) => {
  cy.get(".q-field__messages:visible").should("contain", msg);
});
Then("devo restaurar a senha do usuario", async () => {
  let req = await axios.put("/api/auth", {
    user: {
      email: "peluticaio@gmail.com",
      current_password: "12345",
      password: "1234",
      password_confirmation: "1234",
    },
  });
});
When("eu selecionar o campo senhaantiga e digitar {string}", (valor) => {
  cy.get(`[data-test-senhaantiga="senhaantiga"]`).type(valor);
});
And("selecionar o campo senhaantiga e digitar {string}", (valor) => {
  cy.get(`[data-test-senhaantiga="senhaantiga"]`).type(valor);
});
When("eu selecionar o campo senhanova e digitar {string}", (valor) => {
  cy.get(`[data-test-senhanova="senhanova"]`).type(valor);
});
And("selecionar o campo senhanova e digitar {string}", (valor) => {
  cy.get(`[data-test-senhanova="senhanova"]`).type(valor);
});
When("eu selecionar o campo senhaconfirmacao e digitar {string}", (valor) => {
  cy.get(`[data-test-senhaconfirmacao="senhaconfirmacao"]`).type(valor);
});
And("selecionar o campo senhaconfirmacao e digitar {string}", (valor) => {
  cy.get(`[data-test-senhaconfirmacao="senhaconfirmacao"]`).type(valor);
});
Then("devo ver uma mensagem {string}", (msg) => {
  cy.get(".q-notification__message").should("contain", msg);
});
Then(/^eu devo ser redirecionado para a rota "([^"]*)"$/, (expectedPath) => {
  cy.url().should("include", expectedPath);
});
And(/^(:?|eu )deveria ver [o|a] (\w+)$/, (a, id) => {
  the(id);
});
Then(/^(:?|eu )deveria ver o campo "(\w+)"$/, (a, id) => {
  the(id);
});
And(/^(:?|eu )deveria ver o campo "(\w+)"$/, (a, id) => {
  the(id);
});
Then(/^(:?|eu )deveria ver o botão "(\w+)"$/, (a, id) => {
  the(id, "button");
});
And(/^(:?|eu )clicar no botão "(\w+)"$/, (a, id) => {
  cy.get(`[data-test-button-register=${id}]`).click();
});
And(/^(:?|eu )deveria ver o botão "(\w+)"$/, (a, id) => {
  the(id, "button");
});
And(/^(:?|eu )nao deveria ver [o|a] (\w+)$/, (a, id) => {
  the(id).should("not.exist");
});
And(`eu vou para a rota {string}`, (id) => {
  visit(id);
});
