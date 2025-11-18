@issue-111 (Visualização dos templates criados)
Funcionalidade: Visualizar e Gerenciar Templates
  Como administrador
  Quero visualizar os templates criados
  A fim de poder editar e/ou deletar um template que eu criei

  Contexto:
    Dado que o administrador está autenticado no sistema
    E existe o "Template de Avaliação 2024" criado por ele
    E existe o "Template de Pesquisa" criado por outro administrador
    E o administrador acessa a área de "Gerenciamento de Templates"

  Cenário: Listar templates criados pelo próprio administrador
    Quando o administrador visualiza a lista de templates
    Então o sistema deve exibir o "Template de Avaliação 2024" com opções de "Editar" e "Deletar"
    E o sistema deve exibir o "Template de Pesquisa" sem as opções de "Editar" e "Deletar" (ou em modo somente leitura)

  Cenário: Acesso a tela de edição
    Quando o administrador clica em "Editar" no "Template de Avaliação 2024"
    Então o sistema deve abrir o editor de template, permitindo alterações

  Cenário: Administrador sem templates criados
    Dado que o administrador nunca criou um template
    Quando acessa a área de templates
    Então o sistema deve exibir a mensagem "Nenhum template criado por você"
    E deve sugerir a opção de "Criar Novo Template"