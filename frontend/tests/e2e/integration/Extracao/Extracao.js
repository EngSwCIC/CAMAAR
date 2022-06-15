/* eslint-disable no-undef */
import { Given, Then, And, Before } from "cypress-cucumber-preprocessor/steps";
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
    url: 'http://localhost:3000/import/turmas'
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
    url: 'http://localhost:3000/turmas'
  },
  classes
  ).as('buscaTurmas')
  visit(`/#${pagina}`);
  wait('@buscaTurmas', {timeout: 20000})
});
And(`eu clicar no botão {string}`, (id) => {
  intercept({
    method: 'get',
    url: 'http://localhost:3000/import/turmas'
  }).as('importTurmas')
  get(`#${id}`).click();
  wait('@importTurmas', {timeout: 20000})
});
And(`não retornar nenhuma turma na tabela`, (id) => {
  wait('@buscaTurmas', {timeout: 20000})
  get('#tableSelect tbody tr').should('not.exist')
});
Then(`eu devo ver na tabela uma ou mais turmas`, () => {
  get('#tableSelect tbody tr').should('have.length.greaterThan', 0)
});
Then(`eu devo ver uma notificação de {string}`, (string) => {
  get('.q-notification__message ').should('contain', string)
});
