Feature: Download dos resultados de um formulário em CSV
    Como Administrador
    Quero baixar um arquivo CSV contendo os resultados de um formulário
    A fim de avaliar o desempenho das turmas

    Background:
        Given que o administrador está autenticado no sistema
        And que existem formulários já respondidos pelas turmas
        And que o administrador possui permissão para visualizar os resultados

    Scenario: Download bem-sucedido do arquivo CSV
        When o administrador acessa a página de resultados de um formulário
        And solicita o download do arquivo CSV
        Then o sistema deve gerar o arquivo CSV contendo todas as respostas do formulário
        And deve iniciar automaticamente o download do arquivo

    Scenario: Tentar baixar CSV de formulário sem respostas
        Given que o formulário selecionado não possui respostas registradas
        When o administrador solicita o download do arquivo CSV
        Then o sistema deve impedir a geração do arquivo
        And deve exibir uma mensagem informando que o formulário não possui respostas

    Scenario: Tentar baixar CSV de um formulário inexistente
        When o administrador tenta acessar os resultados de um formulário que não existe mais
        And solicita o download do arquivo CSV
        Then o sistema deve exibir uma mensagem informando que o formulário é inválido ou não encontrado

    Scenario: Erro inesperado ao gerar o CSV
        When o administrador solicita o download do arquivo CSV
        And ocorre um erro interno inesperado durante a geração do arquivo
        Then o sistema deve exibir uma mensagem genérica de erro
        And instruir o administrador a tentar novamente mais tarde
