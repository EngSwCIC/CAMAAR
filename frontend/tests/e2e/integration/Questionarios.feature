#language: pt
Funcionalidade: Preenchimento dos Questionarios
  Eu como aluno
  quero preencher os campos
  a fim de responder às perguntas do questionário

  Contexto: Acesso a lista de questionarios
    Dado que eu esteja logado como aluno
    E que estou na tela de selecao dos questionarios
    E a tela tem questionarios

  Cenario: Acesso a um questionário (feliz)
    Quando  clicar no questionario "teste"
    Entao estou na tela do questionario "teste"


  Cenario: Enviar sem preencher campo obrigatório (triste)
    Dado que estou no questionario "teste"
    E nao preencho campo "textArea" obrigatorio
    E clico em enviar
    Entao devo ver uma mensagem de "Erro"

  Cenario: Enviar com todos campos preenchidos (feliz)
    Dado que estou no questionario "teste"
    E preencho todos os campos
    E clico em enviar
    Entao devo ver um mensagem de "Enviado"

  Cenario: Enviar com todos campos obrigatorios preenchidos (feliz)
    Dado que estou no questionario "teste"
    E preencho todos os campos obrigatorios
    E clico em enviar
    Entao devo ver um mensagem de "Enviado"

