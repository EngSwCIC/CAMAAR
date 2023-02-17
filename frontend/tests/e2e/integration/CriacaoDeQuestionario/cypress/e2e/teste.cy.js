describe("Questionario", () => {
  it("Questionario", () => {
    cy.visit("http://localhost:8080/#/create-survey");

    cy.get("#Página sem título").click();
    cy.get("#Página sem título").clear();
    // cy.xpath("//div[text()'Questionário']").click()

    cy.get("#Adicionar Pergunta").click();
    cy.get("#Titulo da Pergunta").click();
    // cy.xpath("//div[text()'teste 1']").click()
    cy.get("#Tipo da Pergunta").click();
    cy.get("#Texto").click();
    cy.get("#Text").click();
    // cy.xpath("//div[text()'testando caixa de texto']").click()

    cy.get("#Adicionar Pergunta").click();
    cy.get("#Titulo da Pergunta").click();
    // cy.xpath("//div[text()'teste 2']").click()
    cy.get("#Tipo da Pergunta").click();
    cy.get("#Múltipla Escolha").click();

    cy.get("#Adicionar Pergunta").click();
    cy.get("#Titulo da Pergunta").click();
    // cy.xpath("//div[text()'teste 3']").click()

    cy.get("#Adicionar Pergunta").click();
    cy.get("#Titulo da Pergunta").click();
    // cy.xpath("//div[text()'teste 4']").click()
    cy.get("#Tipo da Pergunta").click();
    cy.get("#Escala Linear").click();

    cy.get("#Adicionar Pergunta").click();
    cy.get("#Titulo da Pergunta").click();
    // cy.xpath("//div[text()'teste 5']").click()
    cy.get("deleteQuestion").click();

    cy.get("#Salvar").click();
  });
});
