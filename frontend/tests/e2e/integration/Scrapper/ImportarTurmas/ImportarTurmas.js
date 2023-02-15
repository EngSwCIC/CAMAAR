/* eslint-disable no-undef */
import { Given, When, Then, And, Before } from "cypress-cucumber-preprocessor/steps";
const { get, visit, the, wait, intercept, contains, find, clearLocalStorageCache} = cy;

Before(() => {
  clearLocalStorageCache()
  visit('/')
  the('Email').type('Test')
  the('Senha').type('123')
  the('Login', 'button').click()
})

Before({ tags: '@mockTurmasVazias' },() => {
  intercept({
    method: 'post',
    url: '/api/import/turmas'
  }, {}).as('importarTurmas');
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
    wait('@buscarTurmas', {timeout: 30000});
  } else if (button_text == 'Importar para CAMAAR') {
    intercept({
      method: 'post',
      url: '/api/import/turmas'
    }).as('importarTurmas');
    contains(button_text).click();
    wait('@importarTurmas', {timeout: 30000});
  } else if (button_text == 'Importar para CAMAAR sem selecionar uma turma') {
    contains('Importar para CAMAAR').click();
  }
});


And('eu selecionar a primeira turma', () => {
  get('tbody tr .q-checkbox', {timeout: 30000}).first().click();
});

Then(`eu devo ver na tabela {string} a primeira turma selecionada`, (table_name) => {
  if (table_name == 'Turmas Registradas') {
    get('tbody tr td.text-center:nth-child(2)').first().invoke('text').then((subject_name) => {
      get('tbody tr').should('contain', subject_name);
    })  
  }
})

Then(`eu devo ver uma notificação de {string}`, (string) => {
  get('.q-notification__message ').should('contain', string);
});


// When(`clicar no botão {string}`, (id) => {
//   intercept({
//     method: 'get',
//     url: '/api/turmas'
//   }).as('buscaTurmas')
//   intercept({
//     method: 'post',
//     url: '/api/import/turmas'
//   }).as('importaTurmas')
//   get(`#${id}`, {timeout: 30000}).click();
// });

// And('não retornar nenhuma turma na tabela', (id) => {
//   wait('@buscaTurmas', {timeout: 30000})
//   get('#tableSelect tbody tr').should('not.exist')
// });

// Then('eu devo ver na tabela uma ou mais turmas', () => {
//   wait('@buscaTurmas', {timeout: 30000})
//   get('#tableSelect tbody tr').should('have.length.greaterThan', 0)
// });