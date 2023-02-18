describe('Validate tests', () => {

  it('Deve inserir email e senha para logar', () => {
    cy.visit('http://localhost:8080/#/')
    cy.get('[data-test-email="email"]').type('teste@teste.unb')
   	cy.get('[data-test-senha="senha"]').type('123')
	cy.get('[data-test-button-login="login"] > .q-btn__content').click()
  })

  it('Deve conseguir clicar na aba questionarios', () =>{
  	cy.get('[index="0"]').click()
  })

  it('Deve conseguir clicar na aba questionarios', () =>{
  	cy.get('[index="1"]').click()
  })

  it('Deve conseguir clicar na aba questionarios', () =>{
  	cy.get('[index="2"]').click()
  })

  it('Deve inserir email e senha para registrar', () => {
    cy.visit('http://localhost:8080/#/')
    cy.get('[data-test-button-registro="registrar"]').click()
    cy.get('[data-test-email="email"]').type('teste@teste.unb')
   	cy.get('[data-test-senha="senha"]').type('123')
   	cy.get('[data-test-button-register="registrar"]').click()
  })

})