Feature: Visualizar formulários não respondidos
  Como Participante de uma turma
  Quero visualizar os formulários não respondidos das turmas em que estou matriculado
  A fim de poder escolher qual irei responder

  Background:
    Given que estou autenticado como participante
    And que estou matriculado em 3 turmas diferentes

  Scenario: Visualizar lista de formulários não respondidos (feliz)
    Given que existem formulários disponíveis nas minhas turmas
    When eu acesso a seção "Formulários Pendentes"
    Then eu devo ver apenas os formulários que ainda não respondi
    And cada formulário deve mostrar: turma, disciplina, data de abertura e fechamento

  Scenario: Formulários respondidos não aparecem na lista (feliz)
    Given que já respondi um formulário
    When eu acesso a seção "Formulários Pendentes"
    Then o formulário que respondi não deve aparecer na lista
    And apenas formulários novos ou em aberto devem ser mostrados

  Scenario: Nenhum formulário pendente (triste)
    Given que não há formulários pendentes para responder
    When eu acesso a seção "Formulários Pendentes"
    Then eu devo ver a mensagem "Não há formulários pendentes"

  Scenario: Filtrar formulários por turma (feliz)
    Given que existem formulários não respondidos de diferentes turmas
    When eu seleciono uma turma específica
    Then eu devo ver apenas os formulários daquela turma
    And os formulários de outras turmas devem ser ocultados