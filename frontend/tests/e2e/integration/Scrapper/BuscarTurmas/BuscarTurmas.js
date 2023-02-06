/* eslint-disable no-undef */
import { Given, Then, And, Before } from "cypress-cucumber-preprocessor/steps";
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
    method: 'get',
    url: '/api/import/turmas'
  }, {}).as('buscaTurmas')
})

const classes = {
  classes: [
    {
      "code": "CIC0105",
      "name": "ENGENHARIA DE SOFTWARE",
      "class": {
        "classCode": "T02",
        "semester": "2022.2",
        "time": "35M12"
      }
    },
    {
      "code": "CIC0104",
      "name": "SOFTWARE BASICO",
      "class": {
        "classCode": "T02",
        "semester": "2022.2",
        "time": "46M34"
      }
    },
    {
      "code": "CIC0236",
      "name": "TELEINFORMÁTICA E REDES 2",
      "class": {
        "classCode": "T01",
        "semester": "2022.2",
        "time": "24T45"
      }
    }
  ]
}

Given(`que estou na rota {string}`, (page) => {
  intercept({
    method: 'get',
    url: '/api/turmas'
  },
  classes
  ).as('buscaTurmas')
  visit(`/#${page}`);
  wait('@buscaTurmas', {timeout: 20000})
});

And(`eu clicar no botão {string}`, (button_text) => {
  intercept({
    method: 'get',
    url: '/api/import/turmas'
  }).as('importTurmas')
  contains(button_text).click();
  wait('@importTurmas', {timeout: 20000})
});

And(`a tabela {string} estiver vazia`, (table_name) => {
  wait('@buscaTurmas', {timeout: 20000})
  if (table_name == 'Importar Turmas') {
    get('#tableSelect tbody tr').should('not.exist')
  }
});

Then(`eu devo ver na tabela {string} uma ou mais turmas`, (table_name) => {
  if (table_name == 'Importar Turmas') {
    get('#tableSelect tbody tr').should('have.length.greaterThan', 0)
  }
});

Then(`eu devo ver uma notificação de {string}`, (string) => {
  get('.q-notification__message ').should('contain', string)
});
