# language: pt

Funcionalidade: Visualização de Formulários para Responder
    Eu como Participante de uma turma
    Quero visualizar os formulários não respondidos das turmas em que estou matriculado
    Para que eu possa escolher qual irei responder

    # Happy Path
    Cenário: Visualizar formulários não respondidos
        Dado que estou na página de formulários
        E estou matriculado em ao menos uma turma
        Quando eu visualizar a lista de formulários
        Então devo ver os formulários não respondidos de minhas turmas na lista

    # Sad Path
    Cenário: Não há formulários pendentes
        Dado que estou na página de formulários
        E estou matriculado em ao menos uma turma
        E todos os formulários de minhas turmas já foram respondidos
        Quando eu visualizar a lista de formulários
        Então devo ver uma mensagem informando que não há formulários pendentes

    # Sad Path -> Acho que, nesse caso, podemos deixar a mensagem igual ao cenário anterior
    # Cenário: Não há formulários cadastrados
    #     Dado que estou na página de formulários
    #     E estou matriculado em ao menos uma turma
    #     E não há formulários cadastrados
    #     Quando eu visualizar a lista de formulários
    #     Então devo ver uma mensagem informando que não há formulários cadastrados

    # Sad Path
    Cenário: Não estou matriculado em nenhuma turma
        Dado que estou na página de formulários
        E não estou matriculado em nenhuma turma
        Quando eu visualizar a lista de formulários
        Então devo ver uma mensagem informando que não estou matriculado em nenhuma turma
