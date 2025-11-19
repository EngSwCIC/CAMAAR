Feature: Responder questionário da turma
    Como Participante de uma turma
    Quero responder o questionário sobre a turma em que estou matriculado
    A fim de submeter minha avaliação da turma

    Background:
        Given que o participante está autenticado no sistema
        And que o participante está matriculado em uma ou mais turmas

    Scenario: Responder questionário com todas as respostas válidas
        Given que existem formulários pendentes de resposta para as turmas do participante
        When o participante acessa a lista de formulários pendentes
        And seleciona um formulário de uma turma
        And responde todas as questões obrigatórias com respostas válidas
        And envia o questionário
        Then o sistema deve registrar as respostas
        And deve exibir uma mensagem confirmando o envio com sucesso

    Scenario: Tentar enviar o questionário com questões obrigatórias em branco
        Given que existe um formulário pendente
        When o participante o acessa
        And deixa uma ou mais questões obrigatórias sem resposta
        And tenta enviar o questionário
        Then o sistema deve impedir o envio
        And deve exibir uma mensagem informando que todas as questões obrigatórias devem ser respondidas

    Scenario: Tentar responder um formulário já respondido
        Given que o participante já respondeu o formulário da turma
        When o participante tenta acessá-lo novamente
        Then o sistema deve impedir o acesso
        And deve exibir uma mensagem informando que o formulário já foi respondido

    Scenario: Tentar responder um formulário de turma não matriculada
        When o participante tenta acessar um formulário que não pertence às suas turmas
        Then o sistema deve negar o acesso
        And deve exibir uma mensagem informando que o formulário não está disponível

    Scenario: Erro inesperado ao enviar respostas
        Given que existe um problema interno inesperado no sistema
        When o participante tenta enviar o formulário
        Then o sistema deve exibir uma mensagem genérica de erro
        And instruir o participante a tentar novamente mais tarde
