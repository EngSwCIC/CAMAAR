Funcionalidade: Visualizar templates criados
  Como administrador
  Quero visualizar a lista de templates já criados
  Para poder selecionar, editar, duplicar ou excluir modelos conforme necessário

  @feliz
  Cenário: Visualizar lista de templates com informações básicas
    Dado que estou logado como administrador
    Quando acesso a aba "Templates de Formulários"
    Então vejo uma lista com o nome do template, público-alvo, número de perguntas e status de uso
    E posso clicar em" e "Visualizar detalhes" para ver todas as perguntas

  @feliz
  Cenário: Buscar template por título
    Dado que estou na lista de templates
    Quando digito "Docente 2025" no campo de busca
    Então vejo apenas os templates cujos o título contém "Docente 2025"

  @feliz
  Cenário: Visualizar perguntas de um template
    Dado que estou na listagem de templates
    Quando clico em "Visualizar" ao lado de um template específico
    Então vejo todas as perguntas cadastradas com seus respectivos tipos de resposta

  @triste
  Cenário: Nenhum template encontrado na busca
    Dado que estou na tela de busca de templates
    Quando procuro por um nome inexistente
    Então vejo a mensagem "Nenhum template encontrado com este nome"
    E a lista fica vazia até que eu redefina o filtro