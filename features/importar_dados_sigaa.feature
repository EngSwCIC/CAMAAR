Feature: Importar dados do SIGAA
  Como Administrador
  Quero importar dados de turmas, matérias e participantes do SIGAA
  A fim de alimentar a base de dados do sistema

  Background:
    Given que estou autenticado como administrador

  Scenario: Importação bem-sucedida (feliz)
    Given que existem turmas, matérias e participantes no SIGAA
    When eu realizo a importação de dados
    Then os dados devem ser armazenados na base do sistema
    And eu devo ver a mensagem "Importação concluída com sucesso"

  Scenario: Dados já existentes na base (triste)
    Given que "Turma Engenharia de Software" do SIGAA já existem na base local
    When eu tento importar novamente "Turma Engenharia de Software"
    Then o sistema deve ignorar os registros duplicados
    And eu devo ver a mensagem "Nenhum dado novo foi importado"

  Scenario: Erro de conexão com o SIGAA (triste)
    Given que o SIGAA está indisponível
    When eu tento realizar a importação
    Then o sistema deve exibir a mensagem "Erro ao conectar com o SIGAA"
