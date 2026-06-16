# language: pt

Funcionalidade: Responder formulário
  Como um Participante
  Eu quero preencher e enviar as respostas de um formulário de avaliação
  A fim de concluir minha avaliação sobre a disciplina/professor

  Cenário: Enviar formulário com todas as respostas (Caminho Feliz)
    Dado que eu estou logado como "Participante"
    E eu acesso a página de resposta do formulário "Avaliação de Turma"
    Quando eu preencho todas as questões obrigatórias
    E clico no botão "Enviar Respostas"
    Então o sistema deve salvar minhas respostas
    E o status do formulário deve mudar para "Respondido"
    E o sistema exibe a mensagem "Avaliação enviada com sucesso"

  Cenário: Tentar enviar com campos obrigatórios vazios (Caminho Triste)
    Dado que eu estou logado como "Participante"
    E eu acesso a página de resposta do formulário "Avaliação de Turma"
    Quando eu deixo uma questão obrigatória em branco
    E clico no botão "Enviar Respostas"
    Então o sistema não deve salvar as respostas
    E destaca a questão obrigatória
    E o sistema exibe a mensagem de erro "Por favor, preencha todos os campos obrigatórios"
