Funcionalidade: Responder formulário
  Como  usuário do tipo docente ou discente
  Quero acessar e responder os formulários atribuídos a mim
  Para contribuir com as avaliações de desempenho e registrar minha opinião de forma segura

  @feliz
  Cenário: Responder formulário com sucesso
  Dado que recebi um formulário de avaliação dentro do prazo
  Quando acesso o link na minha área de formulários
  E preencho todas as perguntas obrigatórias
  E clico em "Enviar respostas"
  Então vejo a mensagem "Formulário enviado com sucesso"
  E não posso mais editar ou reenviar as respostas

  @feliz
  Cenário: Formulário com respostas anônimas
  Dado que recebi um formulário configurado como "anônimo"
  Quando envio minhas respostas
  Então o sistema registra as respostas sem associar meu nome ou ID de usuário

  @triste
  Cenário: Tentar enviar sem preencher perguntas obrigatórias
  Dado que estou na tela de resposta de um formulário
  Quando deixo uma ou mais perguntas obrigatórias em branco 
  E clico em "Enviar"
  Então recebo a mensagem "Responda todas as perguntas obrigatórias antes de enviar"
  E o formulário não é submetido até que todas as perguntas sejam preenchidas 


  @triste
  Cenário: Tentar responder fora do prazo
  Dado que o prazo de resposta do formulário terminou
  Quando tento acessá-lo pela minha área de formulários
  Então vejo a mensagem "Este formulário não está mais disponível para resposta"