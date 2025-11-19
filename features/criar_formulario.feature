Feature: Criação de formulários de avaliação
  Como Administrador
  Quero escolher criar um formulário para os docentes ou os discentes de uma turma
  A fim de avaliar o desempenho de uma matéria

  Scenario: Administrador acessa a área de criação de formulários (feliz)
    Given que estou autenticado como Administrador
    When eu acesso a seção de "Gerenciamento" no menu lateral
    Then o sistema deve exibir a opção "Criar Formulário"
    And deve permitir selecionar uma turma para criar o formulário

  Scenario: Criar formulário de avaliação para docentes (feliz)
    Given que estou autenticado como Administrador
    And estou na página de criação de formulário
    When eu seleciono a turma "Turma A"
    And escolho o tipo de público "Docentes"
    And preencho as perguntas do formulário
    And confirmo a criação
    Then o sistema deve registrar o formulário para os docentes da turma "Turma A"
    And deve exibir uma mensagem de confirmação de criação

  Scenario: Criar formulário de avaliação para discentes (feliz)
    Given que estou autenticado como Administrador
    And estou na página de criação de formulário
    When eu seleciono a turma "Turma B"
    And escolho o tipo de público "Discentes"
    And preencho as perguntas do formulário
    And confirmo a criação
    Then o sistema deve registrar o formulário para os discentes da turma "Turma B"
    And deve exibir uma mensagem de confirmação de criação

  Scenario: Administrador tenta criar formulário sem selecionar a turma (triste)
    Given que estou autenticado como Administrador
    And estou na página de criação de formulário
    When eu deixo de selecionar uma turma
    And tento confirmar a criação do formulário
    Then o sistema deve informar que a seleção da turma é obrigatória
    And não deve criar o formulário

  Scenario: Administrador tenta criar formulário sem definir o tipo de público (triste)
    Given que estou autenticado como Administrador
    And estou na página de criação de formulário
    When eu seleciono uma turma
    And não escolho se o formulário é para docentes ou discentes
    And tento confirmar a criação
    Then o sistema deve informar que o tipo de público deve ser selecionado
    And não deve criar o formulário

  Scenario: Administrador tenta criar formulário sem perguntas (triste)
    Given que estou autenticado como Administrador
    And estou na página de criação de formulário
    When eu seleciono uma turma
    And escolho o tipo de público "Docentes"
    And tento criar o formulário sem adicionar perguntas
    Then o sistema deve informar que o formulário deve conter ao menos uma pergunta
    And não deve criar o formulário
