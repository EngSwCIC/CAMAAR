# language: pt

Funcionalidade: Criar formulário de avaliação
    Eu como Administrador
    Quero criar um formulário baseado em um template para as turmas que eu escolher
    A fim de avaliar o desempenho das turmas no semestre atual

    # Happy Path
    Cenário: Criando formulário de avaliação
        Dado que estou na pagina de admin
        E clico em criar formulário
        Entao eu devo ser redirecionado para a pagina de criar formulários
        E escolho quem deve receber o formulário
        E escolho qual template irá ser usado
        Então clico em enviar formulário
        E deve aparecer uma mensagem que foi enviado com sucesso

    # Sad Path
    Cenário: Não existe template
        Dado que estou na pagina de admin
        E clico em criar formulários
        Então deve aparecer uma mensagem informando que não existe template

    # Sad Path
    Cenário: Erro ao criar formulário
        Dado que estou na pagina de admin
        E clico em criar formulário
        Entao eu devo ser redirecionado para a pagina de criar formulários
        E escolho quem deve receber o formulário
        E escolho qual template irá ser usado
        Então clico em enviar formulário
        E deve aparecer uma mensagem que ocorreu um erro durante a criação