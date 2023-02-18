#language: pt
Funcionalidade: Preenchimento dos Questionarios
  Eu como aluno
  quero preencher os campos
  a fim de responder às perguntas do questionário

  Cenario: Acesso a lista de questionarios (feliz)
    Dado que estou na tela de selecao dos questionarios
    Então devo ver questionarios

  Cenario: Acesso a um questionário (feliz)
    Dado que estou na tela de selecao dos questionarios
    Quando clicar no questionario "1"
    Entao eu devo estar na tela "/#/surveys/1"

  Cenario: Enviar sem preencher todos campos obrigatório (triste)
    Dado que estou no questionario "1"
    Quando preencho o radio button da questão 2 com os labels: option 4
    E clico no botão "Enviar"
    Entao nao deve enviar com sucesso

  @interceptingRequest
  Cenario: Enviar com todos campos preenchidos (feliz)
    Dado que estou no questionario "1"
    Quando preencho o textarea da questão 1 com "Uma sugestão"
    E preencho todas as opções do likert da questão 3 com "Discordo totalmente"
    E preencho o radio button da questão 2 com os labels: option 1, option 2, option 5
    E clico no botão Enviar
    Entao deve enviar com sucesso
    E a questão 1 deveria enviar "Uma sugestão"
    E a questão 3 deveria enviar o likert com as opções com "Discordo totalmente"
    E a questão 2 deveria enviar 4

  @interceptingRequest
  Cenario: Enviar com todos campos obrigatorios preenchidos (feliz)
    Dado que estou no questionario "1"
    Quando preencho todas as opções do likert da questão 3 com "Concordo totalmente"
    E preencho o radio button da questão 2 com os labels: option 1
    E clico no botão Enviar
    Entao deve enviar com sucesso
    E a questão 2 deveria enviar 0
    E a questão 3 deveria enviar o likert com as opções com "Concordo totalmente"
