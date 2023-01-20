#language: pt
Funcionalidade: Preenchimento dos Questionarios
  Eu como aluno
  quero preencher os campos
  a fim de responder às perguntas do questionário

  @MockQuestionarios
  Cenario: Acesso a lista de questionarios
  # Supor q estou na tela de questionários.
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
    #preencher detalhadamente
    E preencho todos os campos obrigatorios
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

  Cenario: Um Aluno deseja retirar uma disciplina ao questionário e não esta matriculado em nenhuma disciplina (triste)
    Dado que o aluno não está matriculado em nenhuma disciplina
    Quando clicar no botão "Retirar Disciplina"
    Entao deve ver a mensagem "Sem turmas para retirar"

    Cenario: Um Aluno deseja retirar uma disciplina ao questionário (feliz)
    Dado que está matriculado em alguma disciplina
    E que as matriculas foram selecionadas
    Quando clicar no botão "Retirar Disciplina"
    E disciplinas foram retiradas
    Entao deve ver a mensagem "Sucesso"

    Cenario: Um Aluno deseja retirar uma disciplina ao questionário sem selecionar (triste)
      Dado que está matriculado em alguma disciplina
      Quando clicar no botão "Retirar Disciplina"
      Entao deve ver a mensagem "Turmas não selecionadas"

Funcionalidade: Checagem de Disciplinas em meus questionários
  Eu como aluno
  quero checar as turmas presentes nos meus questionários
  A fim de analisar meu cadastro

    Cenario: Um Aluno deseja verificar as disciplinas em seus questionários porém não
    está matriculado em nenhuma disciplina (triste)
      Dado que o aluno não está matriculado em nenhuma disciplina
      Quando ao tentar clicar no botão "Visualizar Disciplinas"
      Entao deve aparecer um "Dropdown" vazio


    Cenario: Um Aluno deseja verificar as disciplinas em seus questionários com disciplinas matriculadas (feliz)
      Dado que o aluno está matriculado em apenas uma disciplina
      Quando clicar no botão "Visualizar Disciplinas"
      Entao deve aparecer um "Dropdown" com disciplinas matriculadas

Funcionalidade: Atualização de Disciplinas em meus questionários
  Eu como aluno
  quero checar as turmas presentes nos meus questionários
  A fim de atualizar meu cadastro

    Cenario: Um Aluno deseja verificar as disciplinas em seus questionários (feliz)
      Dado que o aluno está matriculado em alguma disciplina
      Quando ao tentar clicar no botão "Visualizar Disciplinas"
      Entao deve aparecer um "Dropdown" com disciplinas matriculadas
