Funcionalidade: Criar template de formulário
  Como administrador
  Quero criar um modelo de formulário com perguntas personalizadas
  Para reutilizá-lo posteriormente em avaliações direcionadas a discentes ou docentes

  @feliz
  Cenário: Criar template com sucesso
  Dado que estou logado como administrador
  Quando clico em "Novo Template"
  E adiciono um título, público-alvo e uma lista de perquntas
  Então consigo salvar o template com sucesso
  E ele aparece na listagem de templates disponiveis

  @feliz
  Cenário: Criar template com perguntas de múltipla escolha e dissertativas
  Dado que estou criando um novo template
  Quando adiciono uma pergunta de múltipla escolha e uma pergunta dissertativa
  Então o sisterma salva ambas corretamente no template
  E reconhece os tipos diferentes de resposta no preview

  @triste
  Cenário: Tentar salvar template sem perguntas
  Dado que estou criando um novo template
  Quando tento salvá-lo sem adicionar nenhuma pergunta
  Então vejo a mensagem "É necessário adicionar pelo menos uma pergunta ao template"
  E o template não é salvo