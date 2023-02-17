import { Given, When, Then } from "cypress-cucumber-preprocessor/steps";

Given("que estou autenticado como coordenador", () => {
  // Autentica o usuário com o perfil de coordenador
  // Pode ser feito de várias maneiras, como através de um formulário de login
});

When('clicar no botão {string}', (botao) => {
  // Clica no botão "Relatórios"
  cy.get(`button:contains(${botao})`).click();
});

Then('eu devo visualizar a página com os relatórios', () => {
  // Verifica se a página de relatórios foi carregada
  cy.url().should("include", "/relatorios");
});