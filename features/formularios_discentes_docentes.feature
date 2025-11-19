Feature: Escolher criar formulário para docentes ou discentes
  Como Administrador
  Quero escolher criar um formulário para os docentes ou os dicentes de uma turma
  A fim de avaliar o desempenho de uma matéria

  Background:
    Given que estou autenticado como administrador
    And que estou criando um novo formulário

  Scenario: Criar formulário para alunos (discentes) (feliz)
    Given que estou na página de criar formulário
    When eu seleciono um template
    And eu escolho as turmas
    And eu seleciono "Discentes" como tipo de avaliador
    And eu clico em "Criar formulário"
    Then o formulário deve ser criado apenas para alunos
    And apenas alunos da turma devem receber notificação

  Scenario: Criar formulário para professores (docentes) (feliz)
    Given que estou na página de criar formulário
    When eu seleciono um template
    And eu escolho as turmas
    And eu seleciono "Docentes" como tipo de avaliador
    And eu clico em "Criar formulário"
    Then o formulário deve ser criado apenas para professores
    And apenas professores da turma devem receber notificação

  Scenario: Avaliadores corretos veem apenas seus formulários (feliz)
    Given que um formulário foi criado para "Discentes"
    When um professor da turma faz login
    Then ele não deve ver este formulário nos pendentes
    And quando um aluno faz login, ele vê o formulário

  Scenario: Criar dois formulários diferentes para mesma turma (feliz)
    Given que estou criando dois formulários para a mesma turma
    When eu crio um formulário para "Discentes"
    And eu crio outro formulário para "Docentes"
    Then os dois formulários devem coexistir
    And cada grupo receberá apenas o formulário destinado a ele