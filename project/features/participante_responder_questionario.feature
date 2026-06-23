# language: pt

Funcionalidade: Responder questionário sobre a turma
  Como um Participante de uma turma
  Quero responder o questionário sobre a turma em que estou matriculado
  A fim de submeter minha avaliação da turma

  Cenário: Envio de questionário com sucesso (Caminho Feliz)
    Dado que estou autenticado no sistema como participante
    E que estou na página do formulário não respondido da minha turma
    Quando eu preencho todas as avaliações corretamente
    E clico no botão de submeter avaliação
    Então o sistema deve salvar os "dados_resposta" vinculados ao meu usuário
    E eu devo ser redirecionado com uma mensagem "Avaliação submetida com sucesso"

  Cenário: Tentativa de envio com dados em branco (Caminho Triste)
    Dado que estou autenticado no sistema como participante
    E que estou na página do formulário não respondido da minha turma
    Quando eu deixo questões obrigatórias em branco
    E clico no botão de submeter avaliação
    Então o sistema não deve processar o envio
    E eu devo ver a mensagem de erro "Por favor, preencha todas as questões obrigatórias"