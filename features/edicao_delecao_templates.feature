# language: pt

Funcionalidade: Edição e deleção de templates
  Como um Administrador
  Eu quero editar ou deletar templates existentes
  A fim de corrigir informações ou remover templates obsoletos

  Cenário: Edição de template com sucesso (Caminho Feliz)
    Dado que eu estou logado como "Administrador"
    E existe um template chamado "Avaliação Final"
    Quando eu clico em "Editar" no template "Avaliação Final"
    E modifico o campo "Nome do Template" para "Avaliação Semestral"
    E clico no botão "Salvar"
    Então o sistema deve atualizar o template
    E exibe a mensagem "Template atualizado com sucesso"

  Cenário: Exclusão de template em uso (Caminho Triste)
    Dado que eu estou logado como "Administrador"
    E existe um template chamado "Avaliação Final" que já foi usado em formulários
    Quando eu clico em "Deletar" no template "Avaliação Final"
    E confirmo a exclusão
    Então o sistema não deve excluir o template
    E exibe a mensagem de erro "Não é possível excluir um template que já possui formulários vinculados"
