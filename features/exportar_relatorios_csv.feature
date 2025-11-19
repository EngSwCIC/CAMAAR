Feature: Baixar resultados de formulário em CSV
  Como Administrador
  Quero baixar um arquivo CSV contendo os resultados de um formulário
  A fim de avaliar o desempenho das turmas

  Background:
    Given que estou autenticado como administrador
    And que existe um formulário com respostas

  Scenario: Exportar resultados com sucesso (feliz)
    Given que um formulário tem respostas de participantes
    When eu clico em "Exportar para CSV"
    Then um arquivo CSV deve ser gerado
    And o arquivo deve conter todas as respostas
    And o arquivo deve estar pronto para download

  Scenario: Arquivo CSV com estrutura correta (feliz)
    Given que vou exportar resultados de um formulário
    When eu clico em "Exportar para CSV"
    Then o arquivo deve ter colunas com: ID da resposta, Participante, Data de resposta, Respostas
    And cada linha deve representar uma resposta individual
    And caracteres especiais devem estar codificados corretamente

  Scenario: Exportar formulário sem respostas (triste)
    Given que um formulário não possui respostas
    When eu tento exportar para CSV
    Then o sistema deve exibir a mensagem "Não há dados para exportar"
    And nenhum arquivo deve ser criado

  Scenario: Exportar apenas respostas de uma turma específica (feliz)
    Given que um formulário foi respondido por múltiplas turmas
    When eu seleciono uma turma específica
    And eu clico em "Exportar para CSV"
    Then o arquivo deve conter apenas as respostas da turma selecionada