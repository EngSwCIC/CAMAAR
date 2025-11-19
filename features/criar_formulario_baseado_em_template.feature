Feature: Criação de formulário a partir de um template
    Como Administrador
    Quero criar um formulário baseado em um template para as turmas que eu escolher
    A fim de avaliar o desempenho das turmas no semestre atual

    Background:
        Given que existem templates cadastrados no sistema
        And que existem turmas disponíveis para o administrador
        And que o administrador está autenticado no sistema

    Scenario: Criar formulário com um template válido para múltiplas turmas
        When o administrador acessa a página de criação de formulários
        And seleciona um template válido da lista de templates disponíveis
        And seleciona uma ou mais turmas válidas
        And confirma a criação do formulário
        Then o sistema deve criar um formulário para cada turma selecionada
        And deve exibir uma mensagem confirmando a criação com sucesso

    Scenario: Criar formulário sem selecionar template
        When o administrador acessa a página de criação de formulários
        And não seleciona nenhum template
        And tenta confirmar a criação do formulário
        Then o sistema deve impedir a criação
        And deve exibir uma mensagem informando que a seleção de template é obrigatória

    Scenario: Criar formulário sem selecionar turmas
        When o administrador acessa a página de criação de formulários
        And seleciona um template válido
        And não seleciona nenhuma turma
        And tenta confirmar a criação
        Then o sistema deve impedir a criação
        And deve exibir uma mensagem informando que é necessário selecionar ao menos uma turma

    Scenario: Criar formulário com template inexistente
        When o administrador tenta criar um formulário
        And seleciona um template que não existe mais ou foi removido
        Then o sistema deve impedir a criação
        And deve exibir uma mensagem informando que o template selecionado é inválido

    Scenario: Erro inesperado ao criar formulário
        When o administrador tenta confirmar a criação do formulário
        And ocorre um erro interno inesperado
        Then o sistema deve exibir uma mensagem genérica de erro
        And instruir o administrador a tentar novamente mais tarde
