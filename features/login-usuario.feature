Feature: Logar com os dados cadastrados
Eu como Usuário do sistema
Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
A fim de responder formulários ou gerenciar o sistema
Obs: Quando o Usuário logado for um admin deve-se mostrar a opção de gerenciamento no menu lateral.

Scenario: Acesso correspondente ao meu tipo de cadastro
Given que eu possuo uma acesso cadastrado como admin/aluno
When adiciono meu e-mail/matrícula e senha
Then clico no botão de entrar
And sou redirecionado ao menu
And o menu lateral mostra opção de gerenciamento, caso for um administrador

Scenario: Acesso não correspondente ao meu tipo de cadastro
Given que eu possuo uma acesso cadastrado como admin/aluno
When adiciono meu e-mail/matrícula e senha
Then clico no botão de entrar
And sou redirecionado ao menu
And o menu lateral não mostra opção de gerenciamento, se for um administrador
