import { Given, When, Then, And, Before } from "cypress-cucumber-preprocessor/steps";
const { get, visit, the, wait, intercept, clearLocalStorageCache} = cy;
Before(() => {
  clearLocalStorageCache()
  visit('/')
  the('Email').type('Testador')
  the('Senha').type('testa')
  the('Login', 'button').click()
})

Given(`que estou na tela de selecao dos questionarios`, () => {
  visit('/#/surveys')
  }
)

Given(/que estou no questionario "(\w+)"/, (string) =>{
  visit("/#/surveys/" + string)
})

And(/nao preencho campo "(\w+)" obrigatorio/, (string) => {
})

And(/clico no botão "(\w+)"/, (string) => {
  the(string, 'button').click()
})

And(/nao preencho campo (\w+) obrigatorio/, (string) => {
  if (string == "textArea"){
    get(':nth-child(4) > .q-card')
  }

})

Then(/devo ver uma mensagem de "(\w+)"/, (string) => {

})



Before({ tags: '@interceptingRequest'},() => {
  cy.intercept('POST', '/api/survey_answers').as('getRequest')
});


When(`preencho o textarea a questão {} com {}`, (numero, string) => {
  cy.get(`#questao-${numero} textarea`).type(string)
});

When (`preencho o radio button da questão {} com os labels: {}`, (numero ,labels) => {
  labels.split(/,\s?/).forEach(label =>
    cy.get(`#questao-${numero} .q-radio__label label`).contains(label).click()
  )
});

When(`clico no botão {}`, (button_content) => {
  cy.get('.q-btn').contains(button_content).click()
  cy.wait('@getRequest').then(interception => {
    cy.wrap(interception.request.body.answers_attributes).as('questoes_enviadas')
  })
});


Then(`devo ver um mensagem de {}`, (string) => {
  get('.q-notification__message').should('contain', string)
});


Then(`o textarea da questão {} deveria enviar {}`, (num_questao, conteudo_testado) => {
  let indice = parseInt(num_questao) - 1
  cy.get('@questoes_enviadas').then(questao => {
    expect(questao[indice].content).to.equal(conteudo_testado)
  });

});


