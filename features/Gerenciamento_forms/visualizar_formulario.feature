Funcionalidade: Visualização de formulários para responder
    Eu como Participante de uma turma
    Quero visualizar os formulários não respondidos das turmas em que estou matriculado
    A fim de poder escolher qual irei responder

    Cenário: Visualizar formulários não respondidos para turmas matriculadas
        Dado que eu estou logado como Participante
        E que eu estou matriculado nas turmas "Turma A" e "Turma B"
        E que existem formulários não respondidos para essas turmas
        Quando eu acesso a seção de formulários disponíveis
        Então eu devo ver os formulários não respondidos para "Turma A" e "Turma B"
        E eu devo ver uma mensagem indicando o número de formulários pendentes "Você tem 2 formulários para responder."

    Cenário: Nenhum formulário pendente
        Dado que eu estou logado como Participante
        E que eu estou matriculado nas turmas "Turma A" e "Turma B"
        E que não existem formulários pendentes
        Quando eu acesso a seção "Formulários Disponíveis"
        Então eu devo ver a mensagem "Você não possui formulários pendentes."
