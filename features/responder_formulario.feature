# language: pt

Funcionalidade: Responder Formulário de Avaliação
  Como Participante de uma turma
  Eu quero responder o questionário sobre a turma em que estou matriculado
  Para que eu possa submeter minha avaliação da turma

  Contexto:
    Dado que estou logado como aluno com email "aluno@unb.br"
    E estou matriculado na turma "CIC0097"
    E existe um formulário ativo para minha turma
    E o formulário contém 5 questões

  # CENÁRIOS FELIZES

  Cenário: Responder formulário com sucesso
    Dado que estou na página de avaliações
    Quando eu clico no formulário "Avaliação Semestral"
    E eu respondo a questão 1 com "O professor tem boa didática"
    E eu respondo a questão 2 com "Sim"
    E eu respondo a questão 3 com nota "8"
    E eu respondo a questão 4 com "O conteúdo foi relevante"
    E eu respondo a questão 5 com "Não"
    E eu clico no botão "Enviar Respostas"
    Então eu devo ver a mensagem "Respostas enviadas com sucesso"
    E eu devo ver esse formulário como "Respondido"

    # CENÁRIOS TRISTES

  Cenário: Tentar responder formulário sem preencher todas as questões obrigatórias
    Dado que estou respondendo o formulário "Avaliação Semestral"
    Quando eu respondo apenas a questão 1 com "Ótimo professor"
    E eu deixo as questões 2, 3, 4 e 5 sem resposta
    E eu clico em "Enviar Respostas"
    Então eu devo ver a mensagem de erro "Por favor, responda todas as questões obrigatórias"
    E as questões não respondidas devem estar destacadas
    E o formulário não deve ser enviado
    E eu devo permanecer na página do formulário