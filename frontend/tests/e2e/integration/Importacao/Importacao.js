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
Before({ tags: '@mockTurmasVazias' },() => {
  intercept({
    method: 'get',
    url: 'http://localhost:3000/turmas'
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
    url: 'http://localhost:3000/turmasCadastradas'
  },
  classes
  ).as('buscaTurmasCadastradas')
  visit(`/#${pagina}`);
  wait('@buscaTurmasCadastradas')
});
And(`clicar no botão {string}`, (id) => {
  intercept({
    method: 'get',
    url: 'http://localhost:3000/turmas'
  }).as('buscaTurmas')
  intercept({
    method: 'post',
    url: 'http://localhost:3000/import/turmas'
  }).as('importaTurmas')
  get(`#${id}`).click();
});
When(`clicar no botão {string}`, (id) => {
  intercept({
    method: 'get',
    url: 'http://localhost:3000/turmas'
  }).as('buscaTurmas')
  intercept({
    method: 'post',
    url: 'http://localhost:3000/import/turmas'
  }).as('importaTurmas')
  get(`#${id}`).click();
});
And(`que eu busquei turmas`, () => {
  intercept({
    method: 'get',
    url: 'http://localhost:3000/turmas'
  }, classes).as('buscaTurmas')
  get('#searchButton').click();
});
When(`eu digitar {string} no campo de pesquisa da tabela de import`, (id) => {
  get('#search').type(id);
  wait(1000);
})
And('selecionar a turma', (id) => {
  get('tbody tr .q-checkbox').click();
});
And('não retornar nenhuma turma na tabela', (id) => {
  wait('@buscaTurmas', {timeout: 10000})
  get('#tableSelect tbody tr').should('not.exist')
});
Then('eu devo ver na tabela uma ou mais turmas', () => {
  wait('@buscaTurmas', {timeout: 10000})
  get('#tableSelect tbody tr').should('have.length.greaterThan', 0)
});
Then('eu devo ver uma notificação de {string}', (string) => {
  get('.q-notification__message ').should('contain', string)
});
And('esperar importar turmas', () => {
  wait('@importaTurmas', {timeout: 10000})
})
