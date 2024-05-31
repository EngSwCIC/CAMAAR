# language: pt
Funcionalidade: Visualização dos templates criados
  Eu como administrador
  Quero visualizar os templantes criados
  Afim de usar para criação de formulários ou editar/deletar

  # FELIZ
  Cenário: Visualizar lista de templates com sucesso
    Dado que estou logado no sistema CAMAAR como administrador
    E acesso a página de visualização de templates
    Então vejo uma lista de todos os templates criados
    E cada template mostra o nome, a descrição e as opções de editar ou deletar

  # FELIZ
  Cenário: Visualizar detalhes de um template específico
    Dado que estou logado no sistema CAMAAR como administrador
    E acesso a página de visualização de templates
    Quando seleciono um template específico da lista
    Então vejo os detalhes completos do template, incluindo todos os itens e configurações

  # TRISTE
  Cenário: Falha ao carregar a lista de templates
    Dado que estou logado no sistema CAMAAR como administrador
    E tento acessar a página de visualização de templates
    Quando ocorre um erro no carregamento dos templates
    Então recebo uma mensagem de erro informando que houve um problema ao carregar a lista de templates
    E a lista de templates não é exibida

  # TRISTE
  Cenário: Nenhum template disponível para visualização
    Dado que estou logado no sistema CAMAAR como administrador
    E acesso a página de visualização de templates
    Quando não há nenhum template criado no sistema
    Então vejo uma mensagem informando que não há templates disponíveis
    E a opção de criar um novo template é exibida