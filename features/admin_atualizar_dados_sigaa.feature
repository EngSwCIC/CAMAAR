Feature: Atualizacao da base de dados com o SIGAA
  As a Administrador
  I want atualizar a base de dados já existente com os dados atuais do sigaa
  So that corrigir a base de dados do sistema

  Background:
    Given que o administrador possui credenciais validas de gestao
    And esta logado no painel administrativo do sistema

  Scenario: Atualizacao bem-sucedida com dados do SIGAA (Happy Path)
    When o administrador solicita a atualizacao manual da base de dados
    And o servico do SIGAA responde corretamente com os dados atuais
    Then o sistema deve processar e atualizar a base de dados existente sem perda de dados criticos
    And deve registrar a data e hora da ultima sincronizacao
    And deve exibir a mensagem de sucesso "Base de dados atualizada e corrigida com sucesso"

  Scenario: Falha na atualizacao devido a erro de comunicacao com o SIGAA (Sad Path)
    When o administrador solicita a atualizacao manual da base de dados
    And o servico do SIGAA encontra-se indisponivel ou retorna erro de integracao
    Then o sistema aborta a operacao de atualizacao
    And nao deve aplicar nenhuma alteracao parcial na base de dados existente
    And deve exibir a mensagem de erro "Falha na sincronizacao: O sistema SIGAA esta indisponivel no momento."