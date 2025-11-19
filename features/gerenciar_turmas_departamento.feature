Feature: Gerenciar turmas apenas do departamento
  Como Administrador
  Quero gerenciar somente as turmas do departamento o qual eu pertenço
  A fim de avaliar o desempenho das turmas no semestre atual

  Background:
    Given que estou autenticado como administrador
    And que pertenço ao departamento "Engenharia de Computação"

  Scenario: Visualizar apenas turmas do departamento (feliz)
    Given que existem turmas de diferentes departamentos
    When eu acesso a listagem de turmas
    Then eu devo ver apenas as turmas do "Departamento de Engenharia de Computação"
    And eu não devo ver turmas de outros departamentos

  Scenario: Criar formulário apenas para turmas do departamento (feliz)
    Given que estou criando um formulário
    When eu seleciono um template
    Then a listagem de turmas deve mostrar apenas turmas do meu departamento
    And eu não devo ter a opção de selecionar turmas de outros departamentos

  Scenario: Administrador de outro departamento vê apenas suas turmas (feliz)
    Given que um outro administrador pertence ao "Departamento de Engenharia Mecânica"
    When ele acessa o sistema
    Then ele deve ver apenas turmas do "Departamento de Engenharia Mecânica"
    And não deve ver minhas turmas

  Scenario: Impossível atualizar turma de outro departamento (triste)
    Given que estou autenticado como administrador
    When eu tento acessar dados de uma turma de outro departamento
    Then o sistema deve retornar erro 403 (Acesso Negado)
    And a operação não deve ser permitida