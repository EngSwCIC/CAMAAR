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
