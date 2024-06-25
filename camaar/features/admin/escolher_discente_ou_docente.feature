# language: pt

Funcionalidade: Criação de Formulário para Docentes ou Discentes 
    Eu como Administrador
    Quero escolher criar um formulário para os docentes ou os discentes de uma turma
    A fim de avaliar o desempenho de uma matéria

    # Happy Path
    Cenário: Criando formulário de avaliação
        Dado estou criando um formulário
        E escolho quem deve receber o formulário
        Quando enviar o formulario
        Então o formulario deve ser enviado apenas para quem eu escolhi


    # Sad Path
    Cenário: Erro ao criar formulário
        Dado estou criando um formulário
        E não escolho quem deve receber o formulário
        Quando enviar o formulario
        Então deve aparecer uma mensagem de erro dizendo que o destinatário do formulario não foi escolhido