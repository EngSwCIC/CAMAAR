# language: pt

Funcionalidade: Edição e deleção de templates

  Como administrador
  Quero editar e/ou deletar templates que eu criei sem afetar os formulários já criados
  A fim de organizar os templates existentes

  Contexto:
    Dado que estou logado como administrador
    E existem templates cadastrados no sistema

  Cenário: Editar template gera nova versão sem afetar formulários existentes
    Dado que existe um template criado
    E existem formulários já criados baseados na versão atual do template
    Quando eu edito o template
    E salvo as alterações
    Então uma nova versão do template deve ser criada
    E a versão anterior deve ser preservada
    E os formulários já criados devem permanecer vinculados à versão antiga

  Cenário: Excluir template com sucesso
    Dado que existe um template criado
    E o template não está em uso por formulários
    Quando solicito a exclusão do template
    E confirmo a exclusão do template
    Então o template deve ser removido com sucesso

  Cenário: Cancelar exclusão de template
    Dado que existe um template criado
    Quando solicito a exclusão do template
    Então devo ser solicitado a confirmar a exclusão
    Quando cancelo a exclusão
    Então o template não deve ser removido

  Cenário: Excluir template inexistente
    Quando tento excluir um template que não existe
    Então devo ver uma mensagem de erro informando que o template não foi encontrado

  Cenário: Editar template inexistente
    Quando tento editar um template que não existe
    Então devo ver uma mensagem de erro informando que o template não foi encontrado

  Cenário: Excluir template em uso por formulários
    Dado que existe um template criado
    E existem formulários baseados nesse template
    Quando tento excluir o template
    Então devo ser impedido de excluir
    E devo ver uma mensagem informando que o template está em uso

  Cenário: Editar template com dados inválidos
    Dado que existe um template criado
    Quando tento salvar o template com dados inválidos
    Então devo ver mensagens de validação
    E nenhuma nova versão deve ser criada

  Cenário: Editar template com campo obrigatório vazio
    Dado que existe um template criado
    Quando tento salvar o template com o campo nome vazio
    Então devo ver mensagem de erro indicando campo obrigatório
    E nenhuma nova versão deve ser criada

  Cenário: Usuário sem permissão tenta editar template
    Dado que estou logado como usuário comum
    Quando tento editar um template
    Então devo ser impedido de realizar a ação
    E devo ver uma mensagem de acesso negado

  Cenário: Usuário sem permissão tenta excluir template
    Dado que estou logado como usuário comum
    Quando tento excluir um template
    Então devo ser impedido de realizar a ação
    E devo ver uma mensagem de acesso negado

  Cenário: Registrar histórico de versões do template
    Dado que existe um template criado
    Quando eu edito o template
    E salvo as alterações
    Então a criação da nova versão deve ser registrada no histórico
    E deve conter usuário e data da alteração

  Cenário: Editar template com múltiplos formulários vinculados
    Dado que existe um template com muitos formulários vinculados
    Quando eu edito o template
    E salvo as alterações
    Então a nova versão deve ser criada com sucesso
    E os formulários devem permanecer vinculados à versão anterior