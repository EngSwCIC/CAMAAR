# language: pt
# features/responder_formulario.feature

Funcionalidade: Responder formulário (#99)
  Como Participante de uma turma
  Quero responder o questionário sobre a turma em que estou matriculado
  A fim de submeter minha avaliação da turma

  Contexto:
    Dado que estou autenticado como um participante válido
    E existe o formulário "Avaliação - Programação I - 2025.1" disponível para minha turma

  @happy
  Cenário: Responder todas as perguntas obrigatórias e enviar o formulário com sucesso
    Dado que estou na página "formularios/Avaliação - Programação I - 2025.1"
    Quando preencho todas as perguntas obrigatórias com respostas válidas
    E clico no botão "Enviar"
    Então devo ver a mensagem "Avaliação enviada com sucesso!"
    E o sistema registra minhas respostas no banco de dados
    E o formulário é bloqueado para nova submissão

  @happy
  Cenário: Visualizar perguntas e tipos de resposta
    Quando eu acesso a página "formularios/Avaliação - Programação I - 2025.1"
    Então devo ver perguntas com alternativas de múltipla escolha
    E devo ver perguntas com campos de texto
    E devo ver o botão "Enviar" desabilitado até preencher todos os campos obrigatórios

  @sad
  Cenário: Tentar enviar o formulário sem responder todas as perguntas obrigatórias
    Quando deixo perguntas obrigatórias em branco
    E clico em "Enviar"
    Então devo ver a mensagem "Responda todas as perguntas obrigatórias antes de enviar"
    E o formulário não é submetido

  @sad
  Cenário: Tentar acessar um formulário que não pertence à turma do participante
    Quando eu acesso diretamente o endereço "formularios/Avaliação - Programação II - 2025.1"
    Então devo ver a mensagem "Você não tem permissão para responder este formulário"
    E sou redirecionado para a página inicial

  @sad
  Cenário: Falha de conexão ao enviar o formulário
    Dado que o servidor está indisponível
    Quando eu clico em "Enviar"
    Então devo ver a mensagem "Erro ao enviar o formulário. Tente novamente mais tarde."
    E as respostas não são perdidas localmente (mantêm-se visíveis na tela)
