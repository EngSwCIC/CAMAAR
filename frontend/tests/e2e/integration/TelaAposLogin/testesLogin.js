describe('Validate tests', () => {

  it('Devo conseguir inserir email e senha para logar', () => {
    cy.visit('http://localhost:8080/#/') //visita a pagina de login
    cy.get('[data-test-email="email"]').type('teste@teste.unb') //insere um email
   	cy.get('[data-test-senha="senha"]').type('123') //insere uma senha
	cy.get('[data-test-button-login="login"] > .q-btn__content').click() //clica no botao de login
  })

  it('Deve conseguir clicar nas abas', () =>{
  	cy.get('[index="0"]').click() //clica no botão questionários
  	cy.get('h1[data-v-89f897da=""]').should('be.visible') //verifica se a palavra questionários está visível
  	cy.get('.card-logged').should('be.visible') //verifica se os cards estão visíveis
  	cy.get('[index="1"]').click() //clica no botão SIGAA
  	cy.get('[index="2"]').click() //clica no botão relatórios
  })

  it('Devo conseguir inserir email e senha para registrar', () => {
    cy.visit('http://localhost:8080/#/') //visita a pagina de login
    cy.get('[data-test-button-registro="registrar"]').click() //clica no botão registrar
    cy.get('[data-test-email="email"]').type('teste@teste.unb') //insere um email
   	cy.get('[data-test-senha="senha"]').type('123') //insere uma senha
   	cy.get('[data-test-button-register="registrar"]').click() //clica no botão efetuar o registro
  })

  it('Devo conseguir entrar na pagina de registro e voltar', () => {
    cy.visit('http://localhost:8080/#/') //visita a pagina de login
    cy.get('[data-test-button-registro="registrar"]').click() //clica no botão registrar
    cy.get('a > .q-btn > .q-btn__content').click() //clica no botão voltar
  })

  it('Devo ver mensagens de erro caso nao ponha email ou senha', () => {
    cy.visit('http://localhost:8080/#/') //visita a pagina de login
    cy.get('[data-test-button-login="login"] > .q-btn__content').click() //clica no botao de login
	cy.get('.q-field__messages > div').should('be.visible')//verifica se a mensagem de email obrigatorio está visivel
	cy.get('.q-icon').should('be.visible')//verifica se o icone de erro está visivel
	cy.get('[data-test-email="email"]').type('teste@teste.unb') //insere um email
    cy.get('[data-test-button-login="login"] > .q-btn__content').click() //clica no botao de login
	cy.get('.q-field__messages > div')//verifica se a mensagem de senha obrigatoria está visivel
	cy.get('.q-icon').should('be.visible')//verifica se o icone de erro está visivel
  })  

})
