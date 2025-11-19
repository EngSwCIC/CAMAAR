Feature: Criar um formulário baseado em um template
Eu como Administrador
Quero criar um formulário baseado em um template para as turmas que eu escolher
A fim de avaliar o desempenho das turmas no semestre atual

Scenario: criação de formulário com sucesso
Given que eu sou administrador
When eu clico no botão criar formulário
And seleciono o template
And seleciono as turmas que receberão o formulário
Then devo receber uma mensagem de formulário criado com sucesso

Scenario: tentativa de criar formulário sem preencher as turmas
Given que eu sou administrador
When eu clico no botão criar formulário
And seleciono o template
And devo receber uma mensagem de erro, falando que não preenchi as turmas
