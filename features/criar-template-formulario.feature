# language: pt

Funcionalidade: Criar template de formulário
    Eu como Administrador
    Quero criar um template de formulário contendo as questões do formulário
    A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

    # Happy Paths

    Cenário: Sucesso na criação de template de formulário
        Dado que eu estou logado no sistema com um usuário do tipo admin
        E que estou na página de criar template de formulário
        E tiver criado todas as questões do formulário
        Quando eu clicar no botão para "criar template de formulário"
        Então será criado o template de formulário
        E uma mensagem de sucesso será mostrada "Template de formulário criado com sucesso"

    # Sad Paths

    Cenário: Erro na criação de template de formulário
        Dado que eu estou logado no sitema com um usuário do tipo admin
        E que estou na página de criar template de formulário
        E tiver criado todas as questões do formulário
        Quando eu clicar no botão "criar template de formulário"
        Mas não terá a quantidade mínima de questões para criar um formulário
        Então não será possível criar o template de formulário
        E também mostrará uma mensagem de falha ao usuário "o template tem que ter pelo menos 4 questões"