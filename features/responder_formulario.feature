# language: pt

Funcionalidade: Visualizar e responder formulário de avaliação
  Como um aluno
  Quero poder visualizar e responder a um formulário de avaliação
  Para dar feedback sobre a turma ou disciplina

  Contexto:
    Dado que eu estou logado como aluno
    E existe um formulário ativo chamado "Avaliação de Turma 2026.1"
    E eu estou na página de formulários disponíveis

  Cenário: Resposta completa ao formulário com sucesso (Happy Path)
    Quando eu clico para responder o formulário "Avaliação de Turma 2026.1"
    Então eu devo visualizar os detalhes e perguntas pertinentes a ele
    Quando eu respondo a pergunta "Como você avalia o professor?" com a opção "Ótimo"
    E eu clico no botão "Enviar Avaliação"
    Então eu devo ver a mensagem "Avaliação enviada com sucesso"
    E o formulário "Avaliação de Turma 2026.1" não deve mais aparecer na minha lista de pendentes

  Cenário: Tentativa de envio com perguntas obrigatórias em branco (Sad Path)
    Quando eu clico para responder o formulário "Avaliação de Turma 2026.1"
    E eu deixo a pergunta obrigatória "Como você avalia o professor?" em branco
    E eu clico no botão "Enviar Avaliação"
    Então eu devo ver a mensagem "Por favor, responda todas as perguntas obrigatórias"
