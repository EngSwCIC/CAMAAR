import { Given, Then, And, Before } from "cypress-cucumber-preprocessor/steps";

Before({ tags: '@logged' }, () => {
    // log the user in code
})

Before({ tags: '@noReportData' }, () => {
    cy.intercept('').as('getClassMeans')
})

Given('que eu estou na rota "{route}"', route => {
    cy.visit(route)
})

Then('eu deveria ver um aviso de "não tenho acesso à página"', () => {
    cy.wait(1000)
    cy.get('[data-test-id=loginPage]').should('be.enabled')
})

Then('devo ver uma mensagem de "não há dados aqui ainda"', () => {
    cy.wait('@getClassMeans')
    cy.get('[data-test-id=noGrades]').should('be.enabled')
})

Then('Então eu deveria ver "as médias das turmas", dispostas em formato de tabela', () => {
    cy.intercept('').as('getClassMeans')
    cy.wait('@getClassMeans')
    cy.get('[data-test-id=gradeTable]').should('be.enabled')
})
