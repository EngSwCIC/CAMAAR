# language: pt

Funcionalidade: Responder Formulário
    Como Participante de uma turma
    Quero responder o questionário sobre a turma em que estou matriculado
    A fim de submeter minha avaliação da turma

    Contexto:
        Dado que estou logado como Participante
        E estou matriculado na turma "TA" da disciplina "ENGENHARIA DE SOFTWARE"
        E existe um formulário pendente para esta turma
        E estou na página de "Avaliações"

  # ==================== CENÁRIOS FELIZES ====================

    Cenário: Submissão de avaliação com sucesso
        Quando clico no botão "Responder" do formulário da turma "TA"
        E preencho todas as questões obrigatórias com valores válidos
        E clico no botão "Enviar Avaliação"
        Então vejo a mensagem de sucesso "Avaliação submetida com sucesso!"
        E o card do formulário da turma "TA" exibe o status "Respondido"

    Cenário: Visualizar formulário já respondido
        Dado que já respondi ao formulário da turma "TA"
        Quando tento clicar no botão "Responder" novamente
        Então o botão deve estar desabilitado
        E vejo o texto "Você já respondeu esta avaliação"

  # ==================== CENÁRIOS TRISTES ====================

    Cenário: Tentativa de submissão de formulário incompleto
        Quando clico no botão "Responder" do formulário da turma "TA"
        E deixo a questão obrigatória "Avaliação do Professor" em branco
        E clico no botão "Enviar Avaliação"
        Então permaneço na página do formulário
        E vejo o alerta "Por favor, responda todas as questões obrigatórias"
        E a questão "Avaliação do Professor" é destacada em vermelho

    Cenário: Tentativa de responder formulário fora do prazo
        Dado que o prazo para o formulário da turma "TA" expirou
        Quando acesso a página de "Avaliações"
        Então não vejo o botão "Responder" para a turma "TA"
        E vejo a mensagem "Avaliação encerrada em 01/06/2026"

    Cenário: Erro ao enviar formulário por falha de conexão
        Quando clico no botão "Responder" do formulário da turma "TA"
        E preencho o formulário
        E perco a conexão com a internet
        E clico no botão "Enviar Avaliação"
        Então vejo a mensagem de erro "Falha na conexão. Tente novamente."
        E minhas respostas preenchidas devem ser preservadas localmente
