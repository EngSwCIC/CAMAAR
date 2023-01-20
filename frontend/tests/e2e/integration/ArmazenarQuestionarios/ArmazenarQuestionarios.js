import {Given, Then, And} from "cypress-cucumber-preprocessor/steps";

//////////////////////////////////////////////////////////
//                     CONTEXTO                         //
//////////////////////////////////////////////////////////

Given("que eu esteja logado como aluno no CAMAAR", () => {
  cy.visit("/");
  cy.get("[type='email']").type('gabrielfaustino99@gmail.com')
  cy.get("[type='password']").type('190013249')
  cy.contains('Entrar').click()
});

And("eu esteja na página de responder o questionário", () => {
    cy.visit("//surveys/1");
});

//////////////////////////////////////////////////////////
//                     CENÁRIO FELIZ                    //
//////////////////////////////////////////////////////////

And("que eu já tenha completado o questionário", () => {
    // implementar type no html da parte de múltipla escolha do questionário
    cy.get('[type="escolha"]').first().check();
    cy.get("/q-field__native q-placeholder").type("Teste");
    cy.contains('Enviar').click();
});

Then("eu consigo enviar o questionário", () => {
    // implementar mensagem de sucesso
    get('.q-notification__message ').should('contain', 'Sucesso ao enviar resposta')
});