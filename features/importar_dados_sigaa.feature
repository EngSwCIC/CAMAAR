Feature: Importar dados do SIGAA
  Como um usuário de acesso privilegiado cadastrado no CAMAAR,
  Quero conseguir improtar dados diretamente do SIGAA
  Para que eu consiga criar preencher o banco de dados rapidamente

  Background:
    Given Usuário está na página de perfil de Gerenciamento

  Scenario: Importação realizada com sucesso
    When ele clica em "Importar dados"
    Then o sistema deve permitir a importação de arquivo JSON contendo os dados a serem cadastrados
    And deve cadastrar os novos registros no banco de dados
    And deve exibir uma mensagem de sucesso com o total de registros importados

  Scenario: Arquivo importado em formato invalido
    When ele clica em "Importar dados"
    Then o sistema deve permitir a importação de arquivo JSON contendo os dados a serem cadastrados
    And ocorre uma falha na importação
    And deve exibir uma mensagem de erro relatando formato invalido de arquivo

  Scenario: Falha no formato de arquivos durante a importação
    When ele clica em "Importar dados"
    Then o sistema deve permitir a importação de arquivo JSON contendo os dados a serem cadastrados
    And deve cadastrar os novos registros no banco de dados
    And algum dos campos recebidos do JSON não condizem com a estrutura do banco de dados
    And deve exibir uma mensagem de erro relatando falha na importação

