Feature: Visualizar formulários criados
  Como Administrador
  Quero visualizar os formulários criados
  A fim de poder gerar um relatório a partir das respostas

  Background:
    Given que estou autenticado como administrador

  Scenario: Listar todos os formulários criados (feliz)
    Given que criei vários formulários
    When eu acesso a seção "Meus Formulários"
    Then eu devo ver uma lista de todos os formulários
    And cada formulário deve mostrar: nome, template usado, turmas, status, data de criação

  Scenario: Formulário mostra quantidade de respostas (feliz)
    Given que um formulário foi respondido por alguns participantes
    When eu visualizo a lista de formulários
    Then cada formulário deve exibir a quantidade de respostas recebidas
    And eu devo conseguir comparar o progresso entre formulários

  Scenario: Acessar detalhes do formulário (feliz)
    Given que existe um formulário criado
    When eu clico em um formulário
    Then eu devo ver os detalhes: questões, data de abertura/fechamento
    And eu devo ter a opção de visualizar respostas

  Scenario: Formulários apenas do meu departamento (feliz)
    Given que administro apenas um departamento
    When eu acesso a seção "Meus Formulários"
    Then eu devo ver apenas os formulários criados para turmas do meu departamento
    And eu não devo ver formulários de outros departamentos