Feature: Visualização de formulários pendentes
  Como Participante de uma turma
  Quero visualizar os formulários não respondidos das turmas em que estou matriculado
  Para poder escolher qual formulário desejo responder

  Scenario: Visualizar os formulários pendentes com sucesso
    Given que o participante está logado no sistema
    And está matriculado em uma ou mais turmas
    And existem formulários pendentes para essas turmas
    When o participante acessa a página de formulários disponíveis
    Then o sistema exibe a lista de formulários não respondidos
    And o participante pode selecionar qual formulário deseja responder

  Scenario: Nenhum formulário disponível para responder
    Given que o participante está logado no sistema
    And está matriculado em uma ou mais turmas
    And não existem formulários pendentes para responder
    When o participante acessa a página de formulários disponíveis
    Then o sistema informa que não há formulários pendentes para responder
    And nenhuma opção de formulário é exibida na lista
