Feature: Criação de template de formulário
    Como Administrador
    Quero criar um template de formulário contendo as questões do formulário
    A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

    Background:
        Given que o administrador está autenticado no sistema
        And que o administrador possui permissão para gerenciar templates

    Scenario: Criar template com título e questões válidas
        When o administrador acessa a página de criação de templates
        And informa um título válido para o template
        And adiciona uma ou mais questões válidas
        And confirma a criação do template
        Then o sistema deve salvar o template
        And deve exibir uma mensagem confirmando a criação com sucesso

    Scenario: Criar template sem informar título
        When o administrador acessa a página de criação de templates
        And não informa um título
        And tenta confirmar a criação
        Then o sistema deve impedir a criação do template
        And deve exibir uma mensagem informando que o título é obrigatório

    Scenario: Criar template sem adicionar questões
        When o administrador acessa a página de criação de templates
        And informa um título válido
        And não adiciona nenhuma questão
        And tenta confirmar a criação
        Then o sistema deve impedir a criação do template
        And deve exibir uma mensagem informando que é necessário adicionar ao menos uma questão

    Scenario: Criar template com questões inválidas ou duplicadas
        When o administrador acessa a página de criação de templates
        And informa um título válido
        And adiciona questões inválidas ou duplicadas
        And tenta confirmar a criação
        Then o sistema deve impedir a criação
        And deve exibir uma mensagem informando que existem questões inválidas ou duplicadas

    Scenario: Erro inesperado ao criar template
        When o administrador tenta confirmar a criação do template
        And ocorre um erro interno inesperado
        Then o sistema deve exibir uma mensagem genérica de erro
        And instruir o administrador a tentar novamente mais tarde
