Feature: Criação de Template de Formulário
  Como Administrador
  Quero criar um template de formulário contendo as questões do formulário
  A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

  Background:
    Given que estou autenticado como administrador

  Scenario: Criação de template bem-sucedida (feliz)
    Given que eu estou na página de criação de templates
    When eu preencho o nome do template com "Avaliação Padrão Semestral"
    And eu adiciono a pergunta "O professor foi claro nas explicações?"
    And eu adiciono a pergunta "Os materiais de aula foram úteis?"
    And eu salvo o template
    Then eu devo ver a mensagem "Template criado com sucesso"
    And o "Avaliação Padrão Semestral" deve aparecer na lista de templates

  Scenario: Tentativa de criar template sem nome (triste)
    Given que eu estou na página de criação de templates
    When eu deixo o nome do template em branco
    And eu adiciono a pergunta "O professor foi claro nas explicações?"
    And eu tento salvar o template
    Then eu devo ver a mensagem "Erro: O nome do template é obrigatório"
    And o template não deve ser criado

  Scenario: Tentativa de criar template sem perguntas (triste)
    Given que eu estou na página de criação de templates
    When eu preencho o nome do template com "Template Vazio"
    And eu NÃO adiciono nenhuma pergunta
    And eu tento salvar o template
    Then eu devo ver a mensagem "Erro: O template deve conter pelo menos uma pergunta"
    And o template não deve ser criado

  Scenario: Tentativa de criar template com nome duplicado (triste)
    Given que já existe um template com o nome "Avaliação Padrão Semestral"
    When eu preencho o nome do template com "Avaliação Padrão Semestral"
    And eu adiciono uma pergunta
    And eu tento salvar o template
    Then eu devo ver a mensagem "Erro: Já existe um template com este nome"
    And o template não deve ser criado