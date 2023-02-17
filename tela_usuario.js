import { Given, When, Then } from "cypress-cucumber-preprocessor/steps";

Given("que estou autenticado como usuario", () => {
  // Autentica o usuário com o perfil de usuario
  // Pode ser feito de várias maneiras
});

When('clicar no botão {string}', (botao) => {
  // Clica no botão "Questionarios"
  cy.get(`button:contains(${botao})`).click();
});

Then('eu devo visualizar a página com os questionarios disponiveis', () => {
  // Verifica se a página de questionarios foi carregada
  cy.url().should("include", "/questionarios");
});