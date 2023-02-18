/// <reference types="cypress" />

describe("Questionario", () => {
  describe("Dado que estou na rota /create-survey", () => {
    beforeEach(() => {
      cy.visit("/");
      cy.get("[data-test-email=email]").type("teste");
      cy.get("[data-test-senha=senha]").type("teste");
      cy.get("[data-test-button-login=login]").click();
      cy.contains("button", "Criar questionário").click();
    });

    it("Altera título do questionário", () => {
      cy.get('input[name="title"]')
        .clear()
        .type("Questionário")
        .should("have.value", "Questionário");
    });

    it("Cria uma nova pergunta", () => {
      cy.get('[name="add-question"]').click();
      cy.get("[name=question-title]").should("have.value", "Pergunta 1");

      cy.get("[name=question-type]").should("have.value", "Caixa de Seleção");
    });

    it("Deleta pergunta", () => {
      cy.get('[name="add-question"]').click();
      cy.get("[name=question-title]").should("have.value", "Pergunta 1");

      cy.get('[name="delete-question"]').click();
      cy.get("[name=question-title]").should("not.exist");
    });
  });
});
