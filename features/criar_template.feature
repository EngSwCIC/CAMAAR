# arquivo de especificação da issue "Criar template de formulário" (Sprint 1)
@issue-102
Feature: Criar template de formulário
  Como administrador
  Quero criar um template de formulário contendo as questões do formulário
  A fim de gerar formulários de avaliação para medir o desempenho das turmas

  Cenário: Criação de template com sucesso (feliz)
    Dado que o administrador acessa a área de templates
    E informa um nome e adiciona pelo menos uma questão
    Quando confirma a criação
    Então o sistema deve salvar o template e disponibilizá-lo para uso em novos formulários

  Cenário: Tentativa de criar template sem questões (triste)
    Dado que o administrador acessa a área de templates
    E deixa a lista de questões vazia
    Quando tenta salvar o template
    Então o sistema deve impedir a criação
    E manter o administrador na página de edição

  Cenário: Tentativa de criar template com nome duplicado (triste)
    Dado que já existe um template cadastrado com o mesmo nome
    Quando o administrador tenta criar outro template com esse nome
    Então o sistema deve rejeitar a criação
    E não alterar os templates existentes