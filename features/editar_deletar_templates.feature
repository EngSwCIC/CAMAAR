@issue-112 (Edição e deleção de templates)
Funcionalidade: Editar e Deletar Template sem afetar Formulários Existentes
  Como administrador
  Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
  A fim de organizar os templates existentes

  Contexto:
    Dado que existe o template "Template A" criado pelo administrador
    E o formulário "Formulário X" foi criado a partir do "Template A" e está em uso
    E o administrador está na página de visualização de templates

  Cenário: Edição bem-sucedida de um template
    Quando o administrador seleciona o "Template A" para edição
    E altera o nome para "Template B - Revisado"
    E salva as alterações
    Então o sistema deve atualizar o template para "Template B - Revisado"
    E o "Formulário X" deve permanecer inalterado e baseado na versão original do template

  Cenário: Deleção de um template não utilizado
    Dado que existe um template "Template Novo" que nunca foi usado para criar um formulário
    Quando o administrador seleciona e confirma a deleção do "Template Novo"
    Então o sistema deve remover permanentemente o "Template Novo" da lista

  Cenário: Deleção de um template utilizado
    Quando o administrador seleciona e confirma a deleção do "Template A"
    Então o sistema deve exibir uma mensagem de confirmação sobre a existência de formulários relacionados
    E, após a confirmação, o "Template A" deve ser removido
    E o "Formulário X" deve continuar existindo e acessível