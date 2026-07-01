# language: pt

Funcionalidade: Visualizar e responder formulário de avaliação
  Como um discente
  Quero poder visualizar e responder a um formulário de avaliação
  Para dar feedback sobre a turma ou disciplina

  Contexto:
    Dado que eu estou logado como discente
    E existe um formulário ativo para minha turma
    E eu estou na página de formulários disponíveis

  Cenário: Resposta completa ao formulário com sucesso (Happy Path)
    Quando eu clico para responder o formulário
    Então eu devo visualizar os detalhes e perguntas pertinentes a ele
    Quando eu respondo todos os campos do formulário
    E eu envio o fomulário
    Então eu devo ver a mensagem "Respostas enviadas com sucesso!"
    E a resposta deve ser registrada no sistema
    E eu não devo mais ser capaz de responder ao mesmo formulário

  Cenário: Tentativa de envio com perguntas obrigatórias em branco (Sad Path)
    Quando eu clico para responder o formulário 
    E eu deixo uma pergunta obrigatória em branco
    E eu envio o formulário
    Então eu devo ver a mensagem "Por favor, responda todas as perguntas obrigatórias"
