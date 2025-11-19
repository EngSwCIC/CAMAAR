Feature: Atualização de Dados do SIGAA
  Como Administrador
  Quero atualizar a base de dados já existente com os dados atuais do SIGAA
  A fim de corrigir a base de dados do sistema

  Background:
    Given que estou autenticado como administrador

  Scenario: Atualização bem-sucedida (dados novos e modificados) (feliz)
    Given que a base local possui a "Turma A" com o aluno "João Silva"
    And o SIGAA possui a "Turma A" com o nome do aluno atualizado para "João Silva Santos"
    And o SIGAA também possui o novo aluno "Maria Costa" na "Turma A"
    When eu realizo a atualização de dados
    Then o nome do aluno na base local deve ser atualizado para "João Silva Santos"
    And a aluna "Maria Costa" deve ser adicionada à "Turma A" na base local
    And eu devo ver a mensagem "Atualização concluída com sucesso"

  Scenario: Correção de dados (remoção de dados antigos) (feliz)
    Given que a base local possui o aluno "Carlos Souza" na "Turma B"
    And o aluno "Carlos Souza" não está mais listado na "Turma B" no SIGAA
    When eu realizo a atualização de dados
    Then o aluno "Carlos Souza" deve ser removido da "Turma B" na base local
    And eu devo ver a mensagem "Atualização concluída com sucesso"

  Scenario: Dados já estão atualizados (triste)
    Given que os dados da base local já estão idênticos aos dados do SIGAA
    When eu realizo a atualização de dados
    Then o sistema não deve realizar nenhuma alteração
    And eu devo ver a mensagem "A base de dados já está atualizada"

  Scenario: Erro de conexão com o SIGAA (triste)
    Given que o SIGAA está indisponível
    When eu tento realizar a atualização
    Then o sistema deve exibir a mensagem "Erro ao conectar com o SIGAA"
    And nenhuma alteração deve ser feita na base local

  Scenario: Fonte de dados não encontrada no SIGAA (triste)
    Given que a base local está configurada para atualizar a "Turma de Engenharia 2020"
    And a "Turma de Engenharia 2020" foi permanentemente excluída do SIGAA
    When eu realizo a atualização de dados
    Then o sistema deve falhar ao buscar os dados
    And eu devo ver a mensagem "Erro: A 'Turma de Engenharia 2020' não foi encontrada no SIGAA. A atualização foi cancelada."
    And nenhuma alteração deve ser feita na base local