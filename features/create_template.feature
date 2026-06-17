Feature: Create Template 

    Eu como Administrador
    Quero criar um template de formulário contendo as questões do formulário
    A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

  Background:
    Given I Am authenticated as an "Administrador"
    Given I Am on the home page
    And I follow "Adicionar novo template"
    And I am on the "Criar novo template" page

  Scenario: Create a template successfully(happy path)

    # Teste de matematica, multipla escolha
    And I have added the template
    | titulo         | Template Prova Matemática 2º semestre |    
    And I add the following elementos:
    | enunciado_elemento           | tipo_campo       | enunciado_campo |
    | Questão 1(2 pontos):         | multipla_escolha | a: b: c: d:     |
    | Questão 2(2 pontos):         | multipla_escolha | a: b: c: d:     |
    | Questão 3(3 pontos):         | multipla_escolha | a: b: c: d:     |   
    | Questão 4(3 pontos):         | multipla_escolha | a: b: c: d:     | 
    | Questão desafio(1 ponto):    | multipla_escolha | a: b: c: d:     | 
    When I press "Salvar"
    Then I should see a success message "Template criado com sucesso!"

    # Teste de portugues, discursivo
    When I follow "Adicionar novo template"
    Given I have added the template
    | titulo         | Template Prova Português 2º semestre  | 
    And I add the following elementos:
    | enunciado_elemento           | tipo_campo       | enunciado_campo |
    | Questão 1(2.5 pontos):       | campo_de_texto   | Resposta:       |
    | Questão 2(2.5 pontos):       | campo_de_texto   | Resposta:       |
    | Questão 3(2.5 pontos):       | campo_de_texto   | Resposta:       |
    | Questão 4(2.5 pontos):       | campo_de_texto   | Resposta:       | 
    | Questão desafio(1 ponto):    | campo_de_texto   | Resposta:       |
    When I press "Salvar"
    Then I should see a success message "Template criado com sucesso!"

    # verificacao final (visualizacao)
    And the template "Template Prova Matemática 2º semestre" should be listed in my templates
    And the template "Template Prova Português 2º semestre" should be listed in my templates

  Scenario: Attempt to create a template without a title(sad path)
    Given I have added the template
    | titulo         | "" |    
    And I add the following elementos:
    | enunciado_elemento | tipo_campo       | enunciado_campo |
    | Questão 1:         | multipla_escolha | a: b: c: d:     |
    When I press "Salvar"
    Then I should see an error message "Título não pode ficar em branco!"

  Scenario: Attempt to create a template without questions(sad path)
    Given I have added the template
    | titulo         | Template Prova Matemática 2º semestre  |   
    And I dont add elementos
    When I press "Salvar"
    Then I should see an error message "Template deve ter pelo menos um elemento!"
