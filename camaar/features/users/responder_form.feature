# language: pt

Funcionalidade: Responder Formulário
    Eu como Participante de uma turma
    Quero responder o questionário sobre a turma em que estou matriculado
    Para que possa submeter minha avaliação da turma

    Cenário: Responder formulário de avaliação
        # Happy Path
        # Dado que estou matriculado na turma "Turma Teste"
        Dado que estou matriculado em ao menos uma turma
        E existe um formulário de avaliação para alguma turma
        Quando eu preencher o formulário de avaliação de uma turma
        E submeter o formulário de avaliação preenchido
        Então devo ver a mensagem "Formulário submetido com sucesso"

    # Sad Path -> Tô deixando esse aqui, mas acho que ele é responsabilidade mais do ver_forms_pendentes.feature.
    # Talvez esse não precise existir
    Cenário: Não estou matriculado em nenhuma turma
        Dado que estou na página de formulários
        E não estou matriculado em nenhuma turma
        Quando eu visualizar a lista de formulários
        Então devo ver uma mensagem informando que não estou matriculado em nenhuma turma
