Feature: Admin cria template para formulários 
  Eu como Administrador
  Quero criar um template de formulário contendo as questões do formulário
  A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

  @happy_path
  Scenario: Happy Path - Admin cria template com uma questão com sucesso
    Given que estou na página de criar template
    When eu preencho o campo 'Nome do template:'
    And clico no botão '+'
    And seleciono o 'Público-alvo:'
    And preencho o campo 'Enunciado da questão:'
    And clico no botão 'Criar'
    Then o novo template deve aparecer na tela de meus templates

  @sad_path
  Scenario: Sad Path - Admin tenta criar template sem preencher o nome
    Given que estou na página de criar template
    When eu deixo o campo 'Nome do template:' vazio
    And adiciono uma questão válida
    And clico no botão 'Criar'
    Then deve aparecer uma mensagem 'O nome do template é obrigatório'