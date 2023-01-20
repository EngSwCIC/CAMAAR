#language: pt
Funcionalidade: Preenchimento dos Questionarios
  Eu como aluno
  quero preencher os campos
  a fim de responder às perguntas do questionário

  @MockQuestionarios
  Cenario: Acesso a lista de questionarios
    Dado que estou na tela de selecao dos questionarios
    Então deveria ver questionarios

  Cenario: Acesso a um questionário (feliz)
    Quando clicar no questionario "teste"
    Entao eu deveria estar na tela do questionario "teste"


  Cenario: Enviar sem preencher campo obrigatório (triste)
    Dado que estou no questionario "teste"
    E nao preencho campo "textArea1" obrigatorio
    E clico no botão "seletor"
    Entao devo ver uma mensagem de "Erro"

  Cenario: Enviar com todos campos preenchidos (feliz)
    Dado que estou no questionario Questionário 1
    E preencho o campo "textArea" sugestoes com "Uma sugestão"
    E preencho o campo "textArea2" julgamento_disciplina com "Um julgamento"
    E preencho o campo "radioButton" com uma opcao.
    E clico no botão enviar
    Entao devo ver um mensagem de "Enviado"
    E o campo "textArea" sugestoes deveria enviar "Uma sugestão"
    E o campo "textArea2" julgamento_disciplina deveria enviar "Um julgamento"
    E o campo "radioButton" opcoes deveria enviar: Opcao1, Opcao2.

  Cenario: Enviar com todos campos obrigatorios preenchidos (feliz)
    Dado que estou no questionario "teste"
    E preencho o campo "textArea2" julgamento_disciplina com "Um julgamento"
    E preencho o campo "radioButton" com uma opcao.
    E clico em enviar
    Entao devo ver um mensagem de "Enviado"
    E o campo "textArea2" julgamento_disciplina deveria enviar "Um julgamento"
    E o campo "radioButton" opcoes deveria enviar: Opcao1, Opcao2.
