# language: pt
# features/criar_formulario.feature

Funcionalidade: Criação de Formulário de Avaliação
  Eu como Administrador
  Quero criar um formulário baseado em um template para as turmas que eu escolher
  A fim de avaliar o desempenho das turmas no semestre atual

Contexto:
  Dado que eu sou um "admin" logado no sistema
  E existe um template "Avaliação de Meio de Semestre"
  E existem as turmas "Engenharia de Software - TA" e "Banco de Dados - TB" importadas do SIGAA

@happy_path
Cenário: Admin cria um formulário para múltiplas turmas
  Dado que eu estou na página "formularios/new"
  Quando eu seleciono o template "Avaliação de Meio de Semestre"
  E eu seleciono as turmas "Engenharia de Software - TA" e "Banco de Dados - TB"
  E eu defino a data de encerramento para "31/12/2025"
  E eu clico no botão "Gerar Formulário"
  Então eu devo ser redirecionado para a página "formularios"
  E eu devo ver a mensagem "Formulário criado com sucesso e associado a 2 turma(s)"

@sad_path
Cenário: Admin tenta criar um formulário sem selecionar um template
  Dado que eu estou na página "formularios/new"
  Quando eu seleciono as turmas "Engenharia de Software - TA"
  E eu clico no botão "Gerar Formulário"
  Então eu devo permanecer na página "formularios/new"
  E eu devo ver a mensagem de erro "É necessário selecionar um template"

@sad_path
Cenário: Admin tenta criar um formulário sem selecionar turmas
  Dado que eu estou na página "formularios/new"
  Quando eu seleciono o template "Avaliação de Meio de Semestre"
  E eu clico no botão "Gerar Formulário"
  Então eu devo permanecer na página "formularios/new"
  E eu devo ver a mensagem de erro "É necessário selecionar pelo menos uma turma"