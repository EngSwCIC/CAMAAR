Feature: Visualizacao de formularios nao respondidos
  As a Participante de uma turma
  I want visualizar os formulários não respondidos das turmas em que estou matriculado
  So that poder escolher qual irei responder

  Background:
    Given que o participante esta logado no sistema
    And esta matriculado em pelo menos uma turma ativa no periodo letivo atual

  Scenario: Participante visualiza a lista de formularios pendentes com sucesso (Happy Path)
    Given que existem formularios abertos e ainda nao respondidos para as turmas do participante
    When o participante acessa a pagina de avaliacoes ou painel principal
    Then o sistema deve exibir uma lista clara com todos os formularios pendentes
    And deve permitir que o participante selecione o formulario desejado para iniciar a resposta

  Scenario: Participante acessa a listagem mas nao possui formularios pendentes (Sad Path)
    Given que o participante ja respondeu a todos os formularios ou suas turmas nao possuem avaliacoes abertas
    When o participante acessa a pagina de avaliacoes ou painel principal
    Then o sistema nao deve listar nenhum formulario para resposta
    And deve exibir a mensagem informativa "Voce nao possui formularios pendentes para responder no momento."