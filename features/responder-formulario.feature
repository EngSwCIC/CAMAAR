# language: pt

Funcionalidade: Responder formulário
    Eu como Participante de uma turma
    Quero responder o questionário sobre a turma em que estou matriculado
    A fim de submeter minha avaliação da turma

    # Happy Paths

    Cenário: Sucesso na resposta de formulário
        Dado que eu estou logado no sistema como Participante
        E que estou na página Avaliação - Nome da Matéria - Semestre
        Quando eu clicar no botão de envio
        O sistema receberá a avaliação
        E mostrará uma mensagem de sucesso ao usuário

    # Sad Paths

    Cenário: Falha na autenticação
        Dado que não estou logado
        Se tento etrar na página Avaliação - Nome da Matéria - Semestre
        Aparecerá uma mensagem de erro dizendo que não estou logado
    
    Cenário: Algum campo está em branco
        Dado que eu estou logado no sitema com um usuário do tipo admin
        E que estou na página de fluxo de gerenciamento do sistema
        Quando eu clicar no botão "Atualizar dados do SIGAA"
        E não respondi todas as questões
        O sistema me mostrará um pop-up falando que não respondi algumas perguntas3