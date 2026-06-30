Feature: Atualizar base de dados com dados do SIGAA
  Como um usuário de acesso privilegiado cadastrado no CAMAAR
  Quero atualizar a base de dados do sistema com as informações atuais do SIGAA
  Para manter os registros do CAMAAR sincronizados com a fonte oficial

  Background:
    Given que o usuário está autenticado com perfil de administrador
    And está na página de atualização de dados do SIGAA
    And existem registros previamente cadastrados no banco de dados

  Scenario: Atualização realizada com sucesso
    When ele seleciona um arquivo válido exportado do SIGAA contendo dados atualizados
    And clica em "atualizar"
    Then o sistema deve identificar os registros já existentes
    And deve atualizar os campos modificados de cada registro
    And deve exibir um resumo informando quantos registros foram atualizados

  Scenario: Atualização sem nenhuma alteração nos dados
    When ele seleciona um arquivo válido cujos dados são identicos aos já cadastrados
    And clica em "atualizar"
    Then o sistema não deve modificar nenhum registro
    And deve exibir uma mensagem informando que nnehuma alteração foi necessária

  Scenario: Atualização com dados faltantes no arquivo
    When ele seleciona um arquivo inválido contendo registros que ainda não existem no banco
    And clica em "atualizar"
    Then deve sinalizar os registros novos encontrados
    And deve informar ao administrador que os arquivos estão com dados faltantes


  Scenario: Tentativa de atualização por usuário sem privilégios
    Given que o usuário autenticado possui perfil sem privilégio de administrador
    When ele tenta acessar a página de atualização de dados do SIGAA
    Then o sistema não deve permitir o acesso
    And deve exibir uma mensagem informando que a operação requer privilégios de administrador

  Scenario: Atualização com arquivo de estrutura inválida
    When ele seleciona um arquivo cujo conteúdo não segue o padrão esperado do SIGAA
    And clica em "atualizar"
    Then o sistema não deve modificar nenhum registro
    And deve exibir uma mensagem de erro informando que a estrutura do arquivo é inválida


  Scenario: Tentativa de atualização sem selecionar arquivo
    When ele clica em "atualizar" sem selecionar nenhum arquivo
    Then o sistema não deve realizar a atualização
    And deve exibir uma mensagem de erro indicando que é necessário selecionar um arquivo
