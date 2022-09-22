/* eslint-disable no-undef */
import { Given, When, Then, And, Before } from "cypress-cucumber-preprocessor/steps";
const { get, visit, the, wait, intercept, clearLocalStorageCache} = cy;
Before(() => {
  clearLocalStorageCache()
  visit('/')
  the('Email').type('Testador')
  the('Senha').type('testa')
  the('Login', 'button').click()
})
Before({ tags: '@mockTurmaCadastradas' },() => {
  intercept({
    method: 'get',
    url: '/api/turmas'
  }, {}).as('buscaTurmas')
})
const classes = {
  classes: [
    {
      "code": "CIC0097",
      "name": "BANCOS DE DADOS",
      "class": {
        "classCode": "TA",
        "semester": "2021.2",
        "time": "35T45"
      }
    },
    {
      "code": "CIC0105",
      "name": "ENGENHARIA DE SOFTWARE",
      "class": {
        "classCode": "TA",
        "semester": "2021.2",
        "time": "35M12"
      }
    },
    {
      "code": "CIC0202",
      "name": "PROGRAMAÇÃO CONCORRENTE",
      "class": {
        "classCode": "TA",
        "semester": "2021.2",
        "time": "35M34"
      }
    }
  ]
}
Given(`que estou na rota {string}`, (pagina) => {
  intercept({
    method: 'get',
    url: '/api/turmas'
  },
  classes
  ).as('buscaTurmasCadastradas')
  visit(`/#${pagina}`);
  wait('@buscaTurmasCadastradas')
});
And(`clicar no botão {string}`, (id) => {
  intercept({
    method: 'get',
    url: '/api/turmas'
  }).as('buscaTurmas')
  intercept({
    method: 'post',
    url: '/api/import/turmas'
  }).as('importaTurmas')
  get(`#${id}`, {timeout: 20000}).click();
});
When(`clicar no botão {string}`, (id) => {
  intercept({
    method: 'get',
    url: '/api/turmas'
  }).as('buscaTurmas')
  intercept({
    method: 'post',
    url: '/api/import/turmas'
  }).as('importaTurmas')
  get(`#${id}`, {timeout: 20000}).click();
});
And(`que eu busquei turmas`, () => {
  intercept({
    method: 'get',
    url: '/api/turmas'
  }, classes).as('buscaTurmas')
  get('#searchButton').click();
});
When(`eu digitar {string} no campo de pesquisa da tabela de importação`, (id) => {
  get('#importTable #search').type(id);
  wait(1000);
})
And('selecionar a turma', () => {
  get('tbody tr .q-checkbox', {timeout: 20000}).first().click();
});
And('não retornar nenhuma turma na tabela', (id) => {
  wait('@buscaTurmas', {timeout: 20000})
  get('#tableSelect tbody tr').should('not.exist')
});
Then('eu devo ver na tabela uma ou mais turmas', () => {
  wait('@buscaTurmas', {timeout: 20000})
  get('#tableSelect tbody tr').should('have.length.greaterThan', 0)
});
Then('eu devo ver uma notificação de {string}', (string) => {
  get('.q-notification__message ').should('contain', string)
});
And('esperar importar turmas', () => {
  wait('@importaTurmas', {timeout: 20000})
});
And('eu devo ver {string} na tabela de turmas cadastradas', (string) => {
  get('#table tbody tr td').should('contain', string)
})
