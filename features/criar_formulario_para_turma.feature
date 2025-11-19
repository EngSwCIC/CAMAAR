Feature: Criação de formulário para docentes ou discentes
    Como Administrador
    Quero escolher criar um formulário para os docentes ou os discentes de uma turma
    A fim de avaliar o desempenho de uma matéria

    Background:
        Given que existe um administrador autenticado
        And que existe ao menos uma turma cadastrada no sistema

    Scenario: Criar formulário para docentes de uma turma
        When o administrador acessa a página de criação de formulário
        And seleciona um template
        And seleciona a turma desejada
        And escolhe criar um formulário destinado aos docentes
        And confirma a criação do formulário
        Then o sistema deve registrar o formulário associado aos docentes da turma selecionada
        And exibir uma mensagem de sucesso

    Scenario: Criar formulário para discentes de uma turma
        When o administrador acessa a página de criação de formulário
        And seleciona um template
        And seleciona a turma desejada
        And escolhe criar um formulário destinado aos discentes
        And confirma a criação do formulário
        Then o sistema deve registrar o formulário associado aos discentes da turma selecionada
        And exibir uma mensagem de sucesso

    Scenario: Criar formulário sem selecionar uma turma
        When o administrador acessa a página de criação de formulário
        And não seleciona nenhuma turma
        And tenta prosseguir com a criação
        Then o sistema deve impedir a criação do formulário
        And exibir uma mensagem informando que a turma é obrigatória

    Scenario: Criar formulário sem definir template
        When o administrador seleciona a turma desejada
        And escolhe criar um formulário para docentes ou discentes
        And não define um template
        And tenta finalizar a criação
        Then o sistema deve exibir uma mensagem indicando que o formulário precisa ter conteúdo
