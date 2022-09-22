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
Then(/^(:?|eu )deveria ver [o|a] (\w+)$/, (a, id) => {
  the(id);
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
And(/^(:?|eu )deveria ver o botão "(\w+)"$/, (a, id) => {
  the(id, 'button');
});
And(/^(:?|eu )nao deveria ver [o|a] (\w+)$/, (a, id) => {
  the(id).should("not.exist");
});
And(`eu vou para a rota {string}`, (id) => {
  visit(id);
});
