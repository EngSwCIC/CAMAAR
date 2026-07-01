# language: pt

Funcionalidade: Visualização dos templates criados

  Como administrador
  Quero visualizar os templates criados
  A fim de poder editar e/ou deletar um template que eu criei

  Contexto:
    Dado que estou logado como administrador

  Cenário: Visualizar templates com sucesso
    Dado que existem templates cadastrados no sistema
    Quando acesso a página de templates
    Então devo ver a lista de templates criados
    E devo poder selecionar um template para visualizar, editar ou excluir

  Cenário: Não existem templates cadastrados
    Dado que não existem templates cadastrados no sistema
    Quando acesso a página de templates
    Então devo ver uma mensagem informando que não há templates disponíveis

  Cenário: Usuário não autenticado tenta acessar templates
    Dado que não estou autenticado
    Quando tento acessar a página de templates
    Então devo ser redirecionado para a página de login

  Cenário: Usuário sem permissão tenta acessar templates
    Dado que estou logado como usuário comum
    Quando tento acessar a página de templates
    Então devo ser impedido de acessar a página
    E devo ver uma mensagem de acesso negado

  Cenário: Buscar template por nome
    Dado que existem templates cadastrados no sistema
    Quando busco o template pelo nome "Relatório da Disciplina"
    Então devo ver apenas os templates correspondentes à busca

  Cenário: Visualizar detalhes de um template
    Dado que existem templates cadastrados no sistema
    Quando seleciono um template da lista
    Então devo ver os detalhes do template

  Cenário: Ordenar lista de templates por nome
    Dado que existem templates cadastrados no sistema
    Quando ordeno os templates por nome em ordem alfabética
    Então devo ver os templates ordenados por nome

  Cenário: Visualizar templates com paginação
    Dado que existem muitos templates cadastrados no sistema
    Quando acesso a página de templates
    Então devo ver os templates divididos em páginas
    E devo poder navegar entre páginas

  Cenário: Erro ao carregar lista de templates
    Dado que ocorre uma falha no servidor
    Quando acesso a página de templates
    Então devo ver uma mensagem de erro ao carregar os templates

  Cenário: Acessar template que foi removido
    Dado que o template foi excluído
    Quando tento acessá-lo diretamente
    Então devo ver uma mensagem informando que o template não existe