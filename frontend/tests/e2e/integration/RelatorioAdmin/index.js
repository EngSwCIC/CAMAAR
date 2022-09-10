import { Given, Then, And } from "cypress-cucumber-preprocessor/steps";
const { visit, the } = cy;

////////////////////////////////////////////////////////////
Given(`que estou na rota {string}`, (pagina) => {
    visit(pagina);
    Then(/^(:?|eu )deveria ver o aviso de"(\w+)"$/, (id) => {
        the(id);
      });
});

///////////////////////////////////////////////////////////
Given(`que estou na rota {string}`, (pagina) => {
    visit(pagina);
    Then('eu deveria ver as {string}, dispostas em formato de tabela', (string) => { 
        the(id) 
    });
    And( 'as {string} devem ser separadas por disciplinas');
});

///////////////////////////////////////////////////////////
Given(`que estou na rota {string}`, (pagina) => {
    visit(pagina);
    Then('eu devo ver uma mensagem de {string}', (id) => {
        the(id).should('contain',"")
    });
});

