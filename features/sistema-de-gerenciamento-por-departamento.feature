# language: pt

Funcionalidade: Sistema de gerenciamento por departamento
    Eu como Administrador
    Quero gerenciar somente as turmas do departamento o qual eu pertenço
    A fim de avaliar o desempenho das turmas no semestre atual

    # Happy Paths

    Cenário: Sucesso
        Dado que sou um Administrador logado no sistema
        E pertenço a um departamento
        Quando eu acessar a página de gerenciamento
        E realizar uma ação de gerenciamento
        Então devo apenas realizar a ação sobre as turmas associadas ao meu departamento

    # Sad Paths

    Cenário: Não estou associado a nenhum departamento
        Dado que sou um Administrador logado no sistema
        Quando eu acessar a página de gerenciamento
        Então devo ver uma mensagem de erro informando que não estou associado a nenhum departamento
        E não devo poder realizar ações de gerenciamento



    Cenário: Não estou autenticado como um Administrador
        Dado que eu sou um usuário
        Quando eu acessar a página de gerenciamento
        Então o sistema irá me redirecionar para a página inicial
        E deve  me exibir uma mensagem de erro informando que não estou autenticado como um Administrador
