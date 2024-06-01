# language: pt
Funcionalidade: Edição e deleção de templates

  Eu como administrador
  Quero editar e/ou deletar um template criado anteriormente sem afetar os formulários já criados com uso deste template
  A fim de gerenciar os templates para os novos formulários

  # FELIZ
  Cenário: Editar um template com sucesso
    Dado que estou logado no sistema CAMAAR como administrador
    E acesso a página de visualização de templates
    Quando seleciono a opção de editar para um template específico
    E faço as alterações desejadas nos itens e configurações
    E salvo as alterações
    Então o template é atualizado com sucesso
    E recebo uma mensagem de confirmação de que o template foi editado

  # FELIZ
  Cenário: Deletar um template com sucesso
    Dado que estou logado no sistema CAMAAR como administrador
    E acesso a página de visualização de templates
    Quando seleciono a opção de deletar para um template específico
    E confirmo a deleção
    Então o template é removido com sucesso
    E recebo uma mensagem de confirmação de que o template foi deletado
    E os formulários já criados com uso deste template não são afetados

  # TRISTE
  Cenário: Falha ao editar um template devido a erro de validação
    Dado que estou logado no sistema CAMAAR como administrador
    E acesso a página de visualização de templates
    Quando seleciono a opção de editar para um template específico
    E faço alterações inválidas nos itens ou configurações
    E tento salvar as alterações
    Então recebo uma mensagem de erro indicando que há problemas com as alterações feitas
    E o template não é atualizado

