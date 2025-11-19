Feature: Importar dados do SIGAA
  Como Administrador
  Quero importar dados de turmas, matérias e participantes do SIGAA
  Para alimentar a base de dados do sistema

  Scenario: Importar dados do SIGAA com sucesso
    Given que o administrador está logado no sistema
    When o administrador solicita a importação dos dados do SIGAA
    Then o sistema lê os arquivos JSON
    And importa somente os dados que não existem na base

  Scenario: Erro ao tentar importar dados duplicados
    Given que o administrador está logado no sistema
    When o administrador solicita a importação dos dados do SIGAA
    Then o sistema detecta registros duplicados
    And exibe uma mensagem de erro informando que a importação não pode ser concluída devido aos dados duplicados
