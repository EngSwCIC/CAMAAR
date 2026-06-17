Feature: Criação de formulário baseado em template
  Eu como Administrador
  Quero criar um formulário baseado em um template para as turmas que eu escolher
  A fim de avaliar o desempenho das turmas no semestre atual

  @happy_path
  Scenario: Happy Path - Criação de formulário com sucesso
    Given que eu acesse a tela de "Criação de Formulários"
    When eu selecionar o template existente "Avaliação Padrão de Semestre"
    And selecionar a matéria "Engenharia de Software" e a turma "TA"
    And clicar em "Publicar Formulário"
    Then o sistema deve salvar o formulário com sucesso
    And exibir a mensagem "Formulário criado e vinculado às turmas com sucesso."
    And o formulário deve ficar disponível para a turma escolhida

  @sad_path
  Scenario: Sad Path - Tentativa de criação de formulário sem base em um template
    Given que eu acesse a tela de "Criação de Formulários"
    When eu deixar o campo de seleção de template em branco
    And selecionar a matéria "Bancos de Dados" e a turma "TA"
    And clicar em "Publicar Formulário"
    Then o sistema não deve permitir a publicação
    And deve exibir a mensagem de erro "Obrigatório: O formulário deve ser baseado em um template existente."