# language: pt

Funcionalidade: Visualização dos templates criados
  Como um Administrador
  Eu quero visualizar todos os templates de formulários criados
  A fim de gerenciar e usar os templates para criar novas avaliações

  Cenário: Visualizar lista de templates (Caminho Feliz)
    Dado que eu estou logado como "Administrador"
    E existem templates previamente criados no sistema
    Quando eu acesso a página de "Meus Templates"
    Então eu devo ver uma tabela com os templates existentes
    E devo ver as opções de visualizar, editar e excluir para cada template

  Cenário: Nenhum template criado (Caminho Triste)
    Dado que eu estou logado como "Administrador"
    E não existem templates no sistema
    Quando eu acesso a página de "Meus Templates"
    Então a tabela de templates deve estar vazia
    E o sistema exibe a mensagem "Nenhum template encontrado. Crie um novo template."
