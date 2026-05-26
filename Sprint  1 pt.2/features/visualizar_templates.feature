# language: pt
Funcionalidade: Visualização dos templates criados
  Como Administrador
  Quero visualizar uma lista com todos os templates de formulário já criados
  A fim de consultar, selecionar ou gerenciar os modelos existentes

  Contexto:
    Dado que o administrador está autenticado no sistema
    E acessa o módulo de "Gerenciamento de Templates"

  Cenário: Listagem de templates com registros existentes (Caminho Feliz)
    Dado que existem templates previamente cadastrados no banco de dados
    Quando o administrador entra na página de listagem
    Então o sistema deve exibir uma tabela contendo o nome, data de criação e quantidade de questões de cada template
    E os botões de ação "Visualizar", "Editar" e "Excluir" devem estar visíveis ao lado de cada registro

  Cenário: Acesso à listagem sem templates cadastrados (Caminho Triste)
    Dado que não há nenhum template cadastrado no sistema
    Quando o administrador entra na página de listagem
    Então a interface não deve exibir a tabela de registros
    E deve exibir a mensagem de estado vazio "Nenhum template de formulário encontrado."