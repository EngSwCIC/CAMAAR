# language: pt
Funcionalidade: Admin criar formulário a partir de um template para as turmas que escolher

  Eu como Administrador
  Quero criar um formulário baseado em um template para as turmas que eu escolher
  A fim de avaliar o desempenho das turmas no semestre atual

  Cenário: Administrador cria formulário com sucesso
    Dado que sou administrador
    E existe pelo menos um template criado por mim
    E existe pelo menos uma turma cadastrada
    Quando eu preencher o nome do formulário
    E selecionar o template e a turma desejada
    E clicar no botão 'Enviar'
    Então devo ver uma mensagem dizendo 'Formulário gerado com sucesso!'
    E as questões do template devem ser clonadas para o novo formulário

  Cenário: Administrador tenta criar formulário sem selecionar um template
    Dado que sou um administrador
    E estou criando um formulário 
    Quando eu tentar criar um formulário sem selecionar nenhum template
    Então o sistema deve exibir uma mensagem dizendo 'É necessário escolher um template base'

  Cenário: Administrador tenta criar formulário sem selecionar nenhuma turma
    Dado que sou um administrador
    E estou criando um formulário
    Quando eu tentar criar um formulário sem selecionar nenhuma turma
    Então o sistema deve exibir uma mensagem dizendo 'É necessário escolher ao menos uma turma'