# language: pt
Funcionalidade: Criar template de formulário

  Eu como Administrador
  Quero criar um template contendo um modelo de formulário dentro das opções que o sistema oferece
  A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

  # FELIZ
  Cenário: Criar template de formulário com sucesso
    Dado que estou logado no sistema CAMAAR como Administrador
    E acesso a página de criação de templates de formulários
    Quando seleciono a opção de criar um novo template
    E escolho um modelo de formulário a partir das opções oferecidas pelo sistema
    E configuro as perguntas e opções desejadas
    E salvo o template
    Então o template de formulário é criado com sucesso
    E recebo uma mensagem de confirmação de que o template foi criado

  # TRISTE
  Cenário: Falha na criação do template devido a falta Itens
    Dado que estou logado no sistema CAMAAR como Administrador
    E acesso a página de criação de templates de formulários
    Quando seleciono a opção de criar um novo template
    E tento salvar o template sem adicionar nenhum item para ser respondido
    Então recebo uma mensagem de erro informando que é necessário adicionar pelo menos um item ao template
    E o template não é salvo

