# language: pt
Funcionalidade: Admin cria template para formulários 

  Eu como Administrador
  Quero criar um template de formulário contendo as questões do formulário
  A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

  Cenário: Admin cria template com uma questão com sucesso
    Dado que estou na página de criar template
    Quando eu preencho o campo 'Nome do template:'
    E clico no botão '+'
    E seleciono o 'Público-alvo:'
    E preencho o campo 'Enunciado da questão:'
    E clico no botão 'Criar'
    Então o novo template deve aparecer na tela de meus templates

  Cenário: Admin tenta criar template sem preencher o nome
    Dado que estou na página de criar template
    Quando eu deixo o campo 'Nome do template:' vazio
    E adiciono uma questão válida
    E clico no botão 'Criar'
    Então deve aparecer uma mensagem 'O nome do template é obrigatório'

  Cenário: Admin tenta adicionar questão sem preencher o enunciado
    Dado que estou na página de criar template
    Quando eu preencho o campo 'Nome do template:'
    E clico no botão '+'
    E não preencho o campo 'Enunciado da questão:'
    E clico no botão 'Criar'
    Então deve aparecer uma mensagem 'Questão não possui enunciado'