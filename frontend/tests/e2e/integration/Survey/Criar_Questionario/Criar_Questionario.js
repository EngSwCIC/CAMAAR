/* eslint-disable no-undef */
import {
  Given,
  When,
  Then,
  And,
  Before,
} from "cypress-cucumber-preprocessor/steps";
const { get, visit, the, wait, intercept, clearLocalStorageCache } = cy;

Before(() => {
  clearLocalStorageCache();
  visit("/");
  the("Email").type("Testador");
  the("Senha").type("testa");
  the("Login", "button").click();
});

And("que eu esteja na página de questionários", () => {
  visit("/#/surveys/create");
});

And(/^(:?|eu )deveria ver o campo "(\w+)"$/, (a, id) => {
  the(id);
});

Then(/^(:?|eu )deveria ver o campo "(\w+)"$/, (a, id) => {
  the(id);
});

And(/^(:?|eu )deveria ver o botão "(\w+)"$/, (a, id) => {
  the(id, "button");
});

Then(/^(:?|eu )deveria ver o botão "(\w+)"$/, (a, id) => {
  the(id, "button");
});

And("eu deveria ver o botão {string}", (id) => {
  the(id, "button");
});

Then("eu deveria ver o campo {string}", (id) => {
  the(id);
});

Given("que eu esteja logado como aluno no CAMAAR", () => {
  expect(true).to.equal(true);
});

And("eu consigo escrever {string} no campo {string}", (text, id) => {
  the(id).type(`${text}`);
});

Then("eu devo ver {string} no campo {string}", (texto, campo) => {
  the(campo).should("contains", `${texto}`);
});
