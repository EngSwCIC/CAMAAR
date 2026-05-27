# language: pt

Funcionalidade: Criar formulário de avaliação
  Como um professor ou administrador
  Quero poder criar um formulário de avaliação
  Para que os alunos possam avaliar a disciplina ou turma

  Contexto:
    Dado que eu estou logado como professor
    E eu estou na página de criação de formulários

  Cenário: Criação de formulário com sucesso (Happy Path)
    Quando eu preencho o título com "Avaliação de Turma 2026.1"
    E eu adiciono uma pergunta do tipo "Múltipla Escolha" com o texto "Como você avalia o professor?"
    E eu clico em "Salvar Formulário"
    Então eu devo ver a mensagem "Formulário criado com sucesso"
    E eu devo ver o formulário "Avaliação de Turma 2026.1" na lista de formulários

  Cenário: Tentativa de criação sem título (Sad Path)
    Quando eu deixo o título em branco
    E eu adiciono uma pergunta do tipo "Texto" com o texto "Quais suas sugestões?"
    E eu clico em "Salvar Formulário"
    Então eu devo ver a mensagem "Título não pode ficar em branco"
