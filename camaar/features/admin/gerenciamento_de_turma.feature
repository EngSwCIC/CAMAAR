# language: pt

Funcionalidade: Sistema de gerenciamento por departamento 
    Eu como Administrador
    Quero gerenciar somente as turmas do departamento o qual eu pertenço
    A fim de avaliar o desempenho das turmas no semestre atual

    # Happy Path
    Cenário: Existem Turmas do departamento do administrador
        Dado que eu estou na pagina de admin
        E existem resultaods de alguma turma do meu departamento
        Quando eu clico para exibir resultados
        Então deve aparecer apenas os resultados das turmas do meu departamento

    # Sad Path
    Cenário: Não existem turmas do departamento do admin
        Dado que eu estou na pagina de admin
        E não existem resultados de turmas do meu departamento
        Quando eu clico para exibir resultados
        Então deve ser exibida uma mensagem de que não há turmas do meu departamento
