Funcionalidade: Criar formulário de avaliação
  Como administrador
  Quero utilizar um template previamente cadastrado
  Para criar um formulário de avaliação e enviá-lo para os usuários (discentes e docentes) responderem

  @feliz
  Cenário: Criar formulário a partir de um template
  Dado que estou logado como administrador
  E que já existe um template chamadо "Avaliação de Docentes - 2025/1"
  Quando seleciono esse template e clico em "Criar formulário de avaliação"
  E defino a data de envio e os destinatários
  Então o sistema gera um novo formulário baseado no template 
  E os usuários definidos recebem notificações para preenchimento

  @feliz
  Cenário: Reutilização de template
  Dado que o template "Satisfação da Disciplina" já foi usado em um formulário anterior
  Quando escolho esse mesmo template para uma nova avaliação
  Então consigo criar um novo formulário com as mesmas perguntas
  E alterar apenas os destinatários e datas, se desejar

  @triste
  Cenário: Tentativa de criar formulário sem template selecionado
  Dado que estou na tela de criação de formulário de avaliação
  Quando tento prosseguir sem selecionar um template
  Então vejo a mensagem "É necessário selecionar um template para criar o formulário"
  E o formulário não é criado

