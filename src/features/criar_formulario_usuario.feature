# language: pt
# features/criar_formulario_bonus_113.feature

Funcionalidade: Criação de Formulário de Avaliação (Admin + Usuários comuns - Bônus)
  Eu como usuário do sistema (Admin, Docente ou Discente)
  Quero criar um formulário baseado em um template para as turmas que eu escolher
  A fim de avaliar o desempenho das turmas no semestre atual

Contexto:
  Dado que existe um template "Avaliação de Meio de Semestre"
  E existem as turmas "Engenharia de Software - TA" e "Banco de Dados - TB" importadas do SIGAA

@happy_path
Cenário: Admin cria um formulário para múltiplas turmas (Admin)
  Dado que eu sou um "admin" logado no sistema
  E eu estou na página "formularios/new"
  Quando eu seleciono o template "Avaliação de Meio de Semestre"
  E eu seleciono as turmas "Engenharia de Software - TA" e "Banco de Dados - TB"
  E eu defino a data de encerramento para "31/12/2025"
  E eu clico no botão "Gerar Formulário"
  Então eu devo ser redirecionado para a página "formularios"
  E eu devo ver a mensagem "Formulário criado com sucesso e associado a 2 turma(s)"
  E o formulário deve estar associado ao template "Avaliação de Meio de Semestre"

@sad_path
Cenário: Admin tenta criar um formulário sem selecionar um template
  Dado que eu sou um "admin" logado no sistema
  E eu estou na página "formularios/new"
  Quando eu seleciono as turmas "Engenharia de Software - TA"
  E eu clico no botão "Gerar Formulário"
  Então eu devo permanecer na página "formularios/new"
  E eu devo ver a mensagem de erro "É necessário selecionar um template"

@sad_path
Cenário: Admin tenta criar um formulário sem selecionar turmas
  Dado que eu sou um "admin" logado no sistema
  E eu estou na página "formularios/new"
  Quando eu seleciono o template "Avaliação de Meio de Semestre"
  E eu clico no botão "Gerar Formulário"
  Então eu devo permanecer na página "formularios/new"
  E eu devo ver a mensagem de erro "É necessário selecionar pelo menos uma turma"

@happy_path
Cenário: Docente cria um formulário para suas turmas (Usuário comum)
  Dado que eu sou um "docente" logado no sistema
  E eu sou responsável pelas turmas "Engenharia de Software - TA"
  E eu estou na página "formularios/new"
  Quando eu seleciono o template "Avaliação de Meio de Semestre"
  E eu seleciono a turma "Engenharia de Software - TA"
  E eu defino a data de encerramento para "15/12/2025"
  E eu clico no botão "Gerar Formulário"
  Então eu devo ser redirecionado para a página "formularios"
  E eu devo ver a mensagem "Formulário criado com sucesso e associado a 1 turma(s)"
  E o formulário deve estar associado ao docente atual

@happy_path
Cenário: Discente cria um formulário para sua própria turma (Usuário comum)
  Dado que eu sou um "discente" logado no sistema
  E eu estou matriculado na turma "Banco de Dados - TB"
  E eu estou na página "formularios/new"
  Quando eu seleciono o template "Avaliação de Meio de Semestre"
  E eu seleciono a turma "Banco de Dados - TB"
  E eu defino a data de encerramento para "20/12/2025"
  E eu clico no botão "Gerar Formulário"
  Então eu devo ser redirecionado para a página "formularios"
  E eu devo ver a mensagem "Formulário criado com sucesso e associado a 1 turma(s)"
  E o formulário deve estar marcado como criado por "discente"

@sad_path
Cenário: Usuário sem permissão tenta criar formulário (Acesso negado)
  Dado que eu sou um "convidado" não autenticado
  E eu estou na página "formularios/new"
  Quando eu tento acessar a funcionalidade de criação (clicar no botão "Gerar Formulário")
  Então eu devo ser redirecionado para a página "login"
  E eu devo ver a mensagem "É necessário estar logado para criar formulários"

