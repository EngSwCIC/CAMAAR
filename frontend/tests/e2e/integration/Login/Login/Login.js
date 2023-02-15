/* eslint-disable no-undef */
import { Given, Then, And } from "cypress-cucumber-preprocessor/steps";
const { visit, the } = cy;
Given(`que estou na rota {string}`, (pagina) => {
  visit(pagina);
});
Given(`que cliquei no {string}`, (id) => {
  the(id).click();
});
Given(`que nao estou autenticado`, () => {
  cy.clearLocalStorageCache();
});
Given(`que o campo email não foi preenchido`, () => {
  cy.get('form').within(() => {
    cy.get('[data-test-email="email"]').should('have.value', '');
  });
});
Given(`que o campo senha não foi preenchido`, () => {
  cy.get('form').within(() => {
    cy.get('[data-test-senha="senha"]').should('have.value', '');
  });
});
Then(/^(:?|eu )deveria ver [o|a] (\w+)$/, (a, id) => {
  the(id);
});
Then('eu deveria ver uma mensagem {string}', (msg) => {
  cy.get('.q-field__messages:visible')
  .should('contain', msg);
});
When('eu selecionar o campo email e digitar {string}', (valor) => {
  cy.get(`[data-test-email="email"]`).type(valor);
});
And('selecionar o campo email e digitar {string}', (valor) => {
  cy.get(`[data-test-email="email"]`).type(valor);
});
When('eu selecionar o campo senha e digitar {string}', (valor) => {
  cy.get(`[data-test-senha="senha"]`).type(valor);
});
And('selecionar o campo senha e digitar {string}', (valor) => {
  cy.get(`[data-test-senha="senha"]`).type(valor);
});
Then('devo ver uma mensagem {string}', (msg) => {
  cy.get('.q-notification__message').should('contain', 'Email ou senha invalidos');
});
Then(/^eu devo ser redirecionado para a rota "([^"]*)"$/, (expectedPath) => {
  cy.url().should('include', expectedPath);
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
  the(id, 'button');
});
And(/^(:?|eu )clicar no botão "(\w+)"$/, (a, id) => {
  cy.get('[data-test-button-login="login"]').click();
});
And(/^(:?|eu )deveria ver o botão "(\w+)"$/, (a, id) => {
  the(id, 'button');
});
And(/^(:?|eu )nao deveria ver [o|a] (\w+)$/, (a, id) => {
  the(id).should("not.exist");
});
And(`eu vou para a rota {string}`, (id) => {
  visit(id);
});
