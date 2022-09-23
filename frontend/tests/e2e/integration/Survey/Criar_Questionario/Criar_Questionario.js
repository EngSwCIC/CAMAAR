/* eslint-disable no-undef */
import {
  Given,
  When,
  Then,
  And,
  Before,
} from "cypress-cucumber-preprocessor/steps";
const { get, visit, the, wait, intercept, clearLocalStorageCache, contains } =
  cy;

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
  the(id).should("have.value", `${text}`);
});

And("eu devo ver o semestre selecionado", () => {
  get(".Selecione_o_semestre").should("contain", "2021.1");
});

And("eu consigo escolher uma data", () => {
  get(".q-date__view").click();
});

And("eu deveria selecionar o semestre", () => {
  get(
    `.Selecione_o_semestre > .q-field__inner > .q-field__control > .q-field__control-container > .q-field__native`,
    { timeout: 20000 }
  )
    .first()
    .click();

  get(`.q-item__section`, { timeout: 20000 }).first().click();
});

And("eu deveria selecionar o tipo de pergunta {string}", (text) => {
  get("#select").click();
  contains(`${text}`).click();
});

And("eu deveria marcar o campo de {string}", (text) => {
  contains(`${text}`).click();
});

And("eu devo apertar o botão {string}", (text) => {
  the(`${text}`, "button").click();
});

And(
  "eu deveria ver uma questão com os campos de {string} e {string} e {string}",
  (optional, discursive, title) => {
    contains(`${optional}`);
    contains(`${discursive}`);
    contains(`${title}`);
  }
);

Given("que eu não escrevo nos campos necessários", () => {
  expect(true).to.equal(true);
});

Then("eu deveria ver um modal de erro", () => {
  contains("Escreva um enunciado para a questão");
});