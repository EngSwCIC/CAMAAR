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

Before({ tags: '@mockTurmasVazias' },() => {
  intercept({
    method: 'get',
    url: '/api/import/turmas'
  }, {}).as('buscaTurmas');
});

Given(`que estou na rota {string}`, (page) => {
  visit(`/#${page}`);
});

And(`eu clicar no botão {string}`, (button_text) => {
  if (button_text == 'Buscar Turmas no SIGAA') {
    intercept({
      method: 'get',
      url: '/api/import/turmas'
    }).as('buscarTurmas');
    contains(button_text).click();
    wait('@buscarTurmas', {timeout: 20000});
  }
});

And(`a tabela {string} estiver vazia`, (table_name) => {
  if (table_name == 'Importar Turmas') {
    get('#tableSelect tbody tr').should('not.exist');
  }
});

Then(`eu devo ver na tabela {string} uma ou mais turmas`, (table_name) => {
  if (table_name == 'Importar Turmas') {
    get('#tableSelect tbody tr').should('have.length.greaterThan', 0);
  }
});

Then(`eu devo ver uma notificação de {string}`, (string) => {
  get('.q-notification__message ').should('contain', string);
});
