#language: pt
Funcionalidade: Preenchimento dos Questionarios
  Eu como aluno
  quero preencher os campos
  a fim de responder às perguntas do questionário

  @MockQuestionarios
  Contexto: Acesso a lista de questionarios #Mudar para cenário.
  # Supor q estou na tela de questionários.
    Dado que estou na tela de selecao dos questionarios
    Então deveria ver questionarios

  Cenario: Acesso a um questionário (feliz)
    Quando  clicar no questionario "teste"
    Entao eu deveria estar na tela do questionario "nome"


  Cenario: Enviar sem preencher campo obrigatório (triste)
    Dado que estou no questionario "teste"
    E nao preencho campo textArea "" obrigatorio
    E clico no botão "seletor"
    Entao devo ver uma mensagem de "Erro"

  Cenario: Enviar com todos campos preenchidos (feliz)
    Dado que estou no questionario "teste"
    E preencho todos os campos #preencher detalhadamente
    E clico no botão "seletor"
    #Verificar formato enviado.
    Entao devo ver um mensagem de "Enviado"

  Cenario: Enviar com todos campos obrigatorios preenchidos (feliz)
    Dado que estou no questionario "teste"
    E preencho todos os campos obrigatorios #preencher detalhadamente
    E clico em enviar
    Entao devo ver um mensagem de "Enviado"
    #Verificar formato enviado.

  # Cenario para multipla
  # Digitei no text area, verifico se chegou o texto q digitei
  # Limpar o banco as mudanças no banco. Provavelmente no hook.

