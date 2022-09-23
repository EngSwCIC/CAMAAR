import { Given, Then, And, Before } from "cypress-cucumber-preprocessor/steps";

Before({ tags: '@noReportData' }, () => {
    cy.intercept('http://localhost:3000/admin_report', []).as('getClassMeans')
})

Given('que estou na rota "/admin/relatorio"', () => {
    cy.visit("/admin/relatorio")
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
    cy.intercept('http://localhost:3000/admin_report', [
        {
            name: 'Engenharia de Software',
            classes: [
                {
                    grade: 55,
                    name: 'T0'
                },
                {
                    grade: 89,
                    name: 'oi'
                },
            ]
        },
        {
            name: 'Engenharia de Software',
            classes: [
                {
                    grade: 55,
                    name: 'T0'
                },
                {
                    grade: 89,
                    name: 'oi'
                },
            ]
        }
    ]).as('getClassMeans')
    cy.wait('@getClassMeans')
    cy.get('[data-test-id=gradeTable]').should('be.enabled')
})
