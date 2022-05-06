/* eslint-disable no-undef */
import { Given, When, Then, And, Before } from "cypress-cucumber-preprocessor/steps";
const { get, visit, the, wait, intercept, clearLocalStorageCache} = cy;
const users = {
  /*Os users tinham muitos outro campos mas não convêm representalos aqui para nossos testes*/
  users: [
    {
      "email": "meuteste@mail.com"
    },
    {
      "email": 'meuteste2@mail.com'
    }
  ]

}
const members = {
  /*Os members tinham muitos outro campos mas não convêm representalos aqui para nossos testes*/
  members: [
    {
      "email": "acjpjvjp@gmail.com"
    },
    {
      "email": "andre.acm97@outlook.com"
    },
    {
      "email": "antoniovmoura.r@gmail.com"
    }
  ]
}
/////////////////////////////////////////////////////////////////////////////////
Given("que eu estou na pagina de registro",() => {
  clearLocalStorageCache()
  visit('/')
  the('registro', 'button').click()
});
Then(/^(:?|eu )deveria ver o campo "(\w+)"$/, (a, id) => {
  the(id);
});
And(/^(:?|eu )deveria ver o campo "(\w+)"$/, (a, id) => {
  the(id);
});
And(/^(:?|eu )deveria ver o botão "(\w+)"$/, (a, id) => {
  the(id, 'button');
});

/////////////////////////////////////////////////////////////////////////////////

When('eu escrever {string} no campo {string}', (text,id)=> {
  the(id).type(`${text}`)
});
And('eu escrever {string} no campo {string}', (text,id)=> {
  the(id).type(`${text}`)
});
And('eu clicar em {string}', (text)=> {
  intercept({
    method: 'post',
    url: 'http://localhost:3030/users'
  }).as('PostMembers')

  the(`${text}`, 'button').click()
});
And('se em members nao existe nenhum membro com o email {string} escrito no campo email', (string) => {
  get('input').invoke('val').then((val1) => {
    members["members"].forEach( (val2) =>{
      expect(val2.email).not.contain(val1)
    })
  })
});
Then('eu devo ver uma notificação de {string}', (string) => {
  get('.q-notification__message ').should('contain', string)
});

////////////////////////////////////////////////////////////////////////////////////

When( 'eu clicar em {string}', (text)=> {
  the(`${text}`, 'button').click()
});
Then('eu devo ver uma notificação no formulario de Senha Obrigatoria e o conteudo no campo da {string} tem que ser vazio', (id) => {
  the(id).should('contain',"")
});
Then('eu devo ver uma notificação no formulario de E-Mail Obrigatório e o conteudo no campo do {string} tem que ser vazio', (id) => {
  the(id).should('contain',"")
});

And('se em users existe algum user com o email {string} escrito no campo email',(string)=> {
  get('input').invoke('val').then((val1) => {
    users["users"].forEach( (val2) =>{
      if (val2.email === val1){
        expect(val2.email).contain(val1)
      }
    })
  })
});

And('se em members existe algum member e nenhum user com o email {string} escrito no campo email', (string)=>{
  get('input').invoke('val').then((val1) => {
    members["members"].forEach( (val2) =>{
      if (val2.email === val1){
        expect(val2.email).contain(val1)
      }
    })
    users["users"].forEach( (val3) =>{
        expect(val3.email).not.contain(val1)
    })
  })
})

