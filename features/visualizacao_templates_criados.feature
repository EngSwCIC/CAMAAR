Feature: Visualização de Templates
  Como Administrador
  Quero visualizar os templates criados
  A fim de poder editar e/ou deletar um template que eu criei

  Background:
    Given que estou autenticado como administrador

  Scenario: Visualizar lista de templates existentes (feliz)
    Given que existem os templates "Template Avaliação Semestral" e "Template Rascunho" cadastrados
    When eu acesso a página de "Meus Templates"
    Then eu devo ver "Template Avaliação Semestral" na lista
    And eu devo ver um botão de "Editar" e "Deletar" ao lado de "Template Avaliação Semestral"
    And eu devo ver "Template Rascunho" na lista
    And eu devo ver um botão de "Editar" e "Deletar" ao lado de "Template Rascunho"

  Scenario: Visualizar quando não há templates cadastrados (triste/alternativo)
    Given que nenhum template foi criado ainda
    When eu acesso a página de "Meus Templates"
    Then eu devo ver a mensagem "Nenhum template encontrado"
    And eu devo ver um botão para "Criar Novo Template"