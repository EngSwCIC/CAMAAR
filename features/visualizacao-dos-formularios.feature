# language: pt

Funcionalidade: Visualizar os templates criados
    Eu como Participante de uma turma
    Quero visualizar os formulários não respondidos das turmas em que estou matriculado
    A fim de poder escolher qual irei responder

    # Happy Path
    Cenário: Visualizar formulários não respondidos
        Dado que eu estou logado no sistema com um usuário do tipo aluno
        E estou matriculado em alguma turma
        Quando eu estiver na página de Formulários
        Então devem aparecer os formulários pendentes na tela principal

    # Sad Path
    Cenário: Não estou matriculado em nenhuma turma
        Dado que eu estou logado no sistema com um usuário do tipo aluno
        E não estou matriculado em nenhuma turma
        Quando eu estiver na página de Formulários
        Então deve aparecer uma mensagem dizendo "Não existem turmas matriculadas" na tela principal

    # Sad Path
    Cenário: Não há formulários para responder
        Dado que eu estou logado no sistema com um usuário do tipo aluno
        E estou matriculado em alguma turma
        Quando eu estiver na página de Formulários
        E não há formulários pendentes
        Então deve aparecer uma mensagem dizendo "Não existem formulários pendentes" na tela principal