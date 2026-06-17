Feature: Criação de Formulário de Avaliação de Turma
  Eu como Administrador
  Quero escolher criar um formulário para os docentes ou os dicentes de uma turma
  A fim de avaliar o desempenho de uma matéria

  Scenario: Criação de formulário de avaliação para docentes com sucesso
    Given que o administrador esteja na tela de "Criação de Formulários"
    When selecionar a matéria "Algoritmos" e a turma "2"
    And definir o público-alvo como "Docentes"
    And preencher ao menos uma pergunta no formulário
    And acionar o botão "Publicar Formulário"
    Then o sistema deve registrar o formulário com sucesso
    And exibir a mensagem de confirmação "Formulário de avaliação para docentes publicado com sucesso."
    And o formulário deve estar disponível para os professores da turma "2"

  Scenario: Tentativa de publicação de formulário sem preencher as perguntas obrigatórias
    Given que o administrador esteja na tela de "Criação de Formulários"
    When selecionar a matéria "Algoritmos" e a turma "2"
    And definir o público-alvo como "Discentes"
    And não adicionar nenhuma pergunta ao formulário
    And acionar o botão "Publicar Formulário"
    Then o sistema deve impedir a publicação do formulário
    And apresentar a mensagem de erro "O formulário precisa ter ao menos uma pergunta antes de ser publicado."
