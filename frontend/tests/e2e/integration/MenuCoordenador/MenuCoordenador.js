/* eslint-disable no-undef */
import { Given, Then, And } from "cypress-cucumber-preprocessor/steps";
const { visit, the, intercept } = cy;
Given(`que estou na rota {string}`, (pagina) => {
  visit(pagina);
});
Given(`que cliquei no {string}`, (id) => {
  the(id).click();
});
Given(`que nao estou autenticado`, () => {
  cy.clearLocalStorage();
});
And(`clicar no botão {string}`, (id) => {
  intercept({
    method: 'get',
    url: '/api/survey'
  }).as('surveys');
});
And(`eu vou para a rota {string}`, (id) => {
  visit(id);
});
