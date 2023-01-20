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
    Dado que estou no questionario Questionário 1
    E preencho o campo textArea sugestoes com "Uma sugestão"
    E preencho o campo textArea julgamento_disciplina com "Um julgamento"
    E preencho o campo radioButton opcoes com: Opcao1, Opcao2.
    E clico no botão enviar
    Entao devo ver um mensagem de "Enviado"
    E o campo textArea sugestoes deveria enviar "Uma sugestão"
    E o campo textArea julgamento_disciplina deveria enviar "Um julgamento"
    E o campo radioButton opcoes deveria enviar: Opcao1, Opcao2.

  Cenario: Enviar com todos campos obrigatorios preenchidos (feliz)
    Dado que estou no questionario "teste"
    E preencho todos os campos obrigatorios #preencher detalhadamente
    E clico em enviar
    Entao devo ver um mensagem de "Enviado"
    #Verificar formato enviado.

  # Cenario para multipla
  # Digitei no text area, verifico se chegou o texto q digitei
  # Limpar o banco as mudanças no banco. Provavelmente no hook.

Funcionalidade: Remoção de disciplina ao questionário durante a resposta
  Eu como aluno
  quero retirar uma disciplina do meu questionário
  A fim de atualizar meu cadastro

  Cenario: Um Aluno deseja retirar uma disciplina ao questionário e não esta matriculado em nenhuma disciplina
    Dado que o aluno não está matriculado em nenhuma disciplina
    Quando ao tentar clicar no botão "Retirar Disciplina"
    Entao ele deve ver o botão "Retirar Disciplina" desabilitado