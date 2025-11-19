    Funcionalidade: Responder formulário
        Eu como Participante de uma turma
        Quero responder o questionário sobre a turma em que estou matriculado
        A fim de submeter minha avaliação da turma

    Cenário: Responder formulário de avaliação para uma turma
        Dado que eu estou logado como Participante
        E que eu estou matriculado na turma "Turma A"
        E que existe um formulário de avaliação disponível para "Turma A"
        Quando eu acesso o formulário de avaliação para "Turma A"
        E eu preencho o formulário com as respostas necessárias
        E eu clico em "Enviar Formulário"
        Então o sistema deve registrar minhas respostas para o formulário de "Turma A"
        E eu devo ver uma mensagem de confirmação "Seu formulário foi enviado com sucesso."

    Cenário: Tentativa de enviar formulário sem preencher campos obrigatórios
        Dado que eu estou logado como Participante
        E que existe um formulário de avaliação ativo para "Turma A"
        Quando eu acesso o formulário de avaliação de "Turma A"
        E eu envio o formulário sem preencher os campos obrigatórios
        Então eu devo ver uma mensagem de erro indicando os campos faltantes
        E as respostas não devem ser registradas
    
    Cenário: Tentativa de enviar formulário sem preencher campos obrigatórios
        Dado que eu estou logado como Participante
        E que existe um formulário de avaliação ativo para "Turma A"
        Quando eu acesso o formulário de avaliação de "Turma A"
        E eu envio o formulário sem preencher os campos obrigatórios
        Então eu devo ver uma mensagem de erro indicando os campos faltantes
        E as respostas não devem ser registradas






