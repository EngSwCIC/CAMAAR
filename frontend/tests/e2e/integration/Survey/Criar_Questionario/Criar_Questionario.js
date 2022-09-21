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

And("eu devo ver {string} no campo {string}", (text, id) => {
  the(id).should("contains", `${text}`);
});

// And(/^(:?|eu )deveria selecionar [o|a] (\w+)$/, (id) => {
// });

And("eu deveria selecionar o semestre", () => {
  get(
    `.Selecione_o_semestre > .q-field__inner > .q-field__control > .q-field__control-container > .q-field__native`,
    { timeout: 20000 }
  )
    .first()
    .click();

  get(
    `.q-item__section`,
    { timeout: 20000 }
  )
    .first()
    .click();
});
