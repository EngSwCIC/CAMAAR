/* eslint-disable no-undef */
import { Given, Then, And } from "cypress-cucumber-preprocessor/steps";
const { visit, the } = cy;
Given(`que estou na rota {string}`, (pagina) => {
  visit(pagina);
});
And(`eu cliquei no botão {string}`, (id) => {
  the(id).click();
});
And(`não retornar nenhuma turma na tabela`, (id) => {
  the(id).click();
});
Then(`eu devo ver na tabela uma ou mais turmas`, () => {
  visit(id);
});
Then(`eu devo ver uma notificação de "Falha ao buscar turmas."`, () => {
    visit(id);
});
