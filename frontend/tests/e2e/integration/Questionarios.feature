#language: pt
Funcionalidade: Preenchimento dos Questionarios
  Eu como aluno
  quero preencher os campos
  a fim de responder às perguntas do questionário

  @MockQuestionarios
#  Cenario: Acesso a lista de questionarios
#    Dado que estou na tela de selecao dos questionarios
#    Então deveria ver questionarios
#
#  Cenario: Acesso a um questionário (feliz)
#    Quando clicar no questcd ionario "teste"
#    Entao eu deveria estar na tela do questionario "teste"


  Cenario: Enviar sem preencher campo obrigatório (triste)
    Dado que estou no questionario "1"
    E nao preencho campo textArea obrigatorio
    E clico no botão "Enviar"
    Entao devo ver uma mensagem de "Erro"

  @interceptingRequest
  Cenario: Enviar com todos campos preenchidos (feliz)
    Dado que estou no questionario "1"
    Quando preencho o textarea a questão 1 com "Uma sugestão"
    E preencho o textarea a questão 3 com "Outra Sugestão"
    E preencho o radio button da questão 2 com os labels: option 1, option 2, option 5
    E clico no botão Enviar
    #Entao devo ver um mensagem de Enviado.
    Entao o textarea da questão 1 deveria enviar "Uma sugestão"
    E o textarea da questão 3 deveria enviar "Outra Sugestão"
    #E o campo "radioButton" opcoes deveria enviar: Opcao1, Opcao2.

#
#  Cenario: Enviar com todos campos obrigatorios preenchidos (feliz)
#    Dado que estou no questionario "teste"
#    E preencho o campo "textArea2" julgamento_disciplina com "Um julgamento"
#    E preencho o campo "radioButton" com uma opcao.
#    E clico em enviar
#    Entao devo ver um mensagem de "Enviado"
#    E o campo "textArea2" julgamento_disciplina deveria enviar "Um julgamento"
#    E o campo "radioButton" opcoes deveria enviar: Opcao1, Opcao2.
