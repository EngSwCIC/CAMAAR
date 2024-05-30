# language: pt

Funcionalidade: Criação de formulário para docentes ou dicentes
    Eu como Administrador
    Quero escolher criar um formulário para os docentes ou os dicentes de uma turma
    A fim de avaliar o desempenho de uma matéria


    # Happy Paths

    Cenário: Sucesso no envio
        Dado que eu estou logado no sistema como Administrador
        E que estou na página de gerenciamento
        Quando clico em Enviar Formulários
        E seleciono o template e a turma 
        E clico no botão de enviar
        O sistema envio o formulário para todos os alunos
        E mostrará uma mensagem de sucesso ao Administrador

    # Sad Paths

    Cenário: Template ou turma não escolhidos
        Dado que eu estou logado no sistema como Administrador
        E que estou na página de gerenciamento
        Quando clico em Enviar Formulários
        E não selecionei o template ou a turma
        O sistema mostrará um pop up dizendo que não selecionei template e turma