# language: pt

Funcionalidade: Criar formulário de avaliação
    Eu como Administrador
    Quero criar um formulário baseado em um template para as turmas que eu escolher
    A fim de avaliar o desempenho das turmas no semestre atual

    # Happy Paths

    Cenário: Sucesso na criação de formulário
        Dado que eu estou logado no sistema com um usuário do tipo admin
        E que estou na página de criar formulário
        E tiver escolhido um template para meu formulário
        Quando eu clicar no botão para "criar formulário"
        Então será criado o formulário
        E uma mensagem de sucesso será mostrada "Formulário criado com sucesso"

    # Sad Paths

    Cenário: Erro na criação de formulário
        Dado que eu estou logado no sitema com um usuário do tipo admin
        E que estou na página de criar formulário
        Quando eu clicar no botão "criar formulário"
        Mas não terá escolhido um template de base
        Então não será possível criar o formulário
        E também mostrará uma mensagem de falha ao usuário "é preciso escolher um template para o formulário"