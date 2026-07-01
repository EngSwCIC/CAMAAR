# language: pt

@javascript
Funcionalidade: Criar formulário para Docentes e Dicentes
    Como um Administrador
    Quero escolher criar um formulário para os docentes ou os dicentes de uma turma
    A fim de avaliar o desempenho de uma matéria

    Contexto:
        Dado que existem turmas e templates para criação de formulários
        E que estou logado como Administrador
        E estou na página "Gerenciamento"
        E clico no botão "Criar Formulário"
        Então um modal é exibido com os campos "Tipo de Destinatário", "Template", "Turma(s)" e data de disponibilidade

  # ==================== CENÁRIOS FELIZES ====================

    Cenário: Criar formulário para dicentes de uma turma
        Quando seleciono "Dicentes" no campo "Tipo de Destinatário"
        E seleciono o template "Avaliação Engenharia de Software" no dropdown "Template"
        E seleciono a turma "CIC0105" no campo "Turma(s)"
        E preencho a data de início com "26/05/2026"
        E preencho a data de término com "01/06/2026"
        E clico no botão "Criar"
        Então o modal é fechado
        E vejo a mensagem de sucesso "Formulário criado com sucesso para dicentes"
        E o formulário fica disponível para os dicentes da turma "CIC0105"

    Cenário: Criar formulário para docentes de uma turma
        Quando seleciono "Docentes" no campo "Tipo de Destinatário"
        E seleciono o template "Avaliação de Didática" no dropdown "Template"
        E seleciono a turma "CIC0105" no campo "Turma(s)"
        E preencho a data de início com "26/05/2026"
        E preencho a data de término com "01/06/2026"
        E clico no botão "Criar"
        Então o modal é fechado
        E vejo a mensagem de sucesso "Formulário criado com sucesso para docentes"
        E o formulário fica disponível para os docentes da turma "CIC0105"

    Cenário: Criar formulário para múltiplas turmas simultaneamente
        Quando seleciono "Dicentes" no campo "Tipo de Destinatário"
        E seleciono o template "Avaliação Engenharia de Software" no dropdown "Template"
        E seleciono a turma "CIC0105" no campo "Turma(s)"
        E clico no campo "Turma(s)" novamente para adicionar mais turmas
        E seleciono a turma "CIC0202" no campo "Turma(s)"
        E preencho a data de início com "26/05/2026"
        E preencho a data de término com "01/06/2026"
        E clico no botão "Criar"
        Então o modal é fechado
        E vejo a mensagem de sucesso "Formulário criado com sucesso para 2 turmas"
        E o formulário fica disponível para os dicentes das turmas "CIC0105" e "CIC0202"

    Cenário: Visualizar formulário criado na lista de formulários ativos
        Dado que criei um formulário para dicentes da turma "CIC0105" com o template "Avaliação Engenharia de Software"
        Quando acesso a página "Gerenciamento - Formulários Ativos"
        Então vejo na tabela uma linha com os dados do formulário criado
        E a linha contém "Dicentes", "CIC0105", "Avaliação Engenharia de Software" e as datas de vigência

    Cenário: Dicente visualiza formulário criado no painel de Avaliações
        Dado que um formulário foi criado para dicentes da turma "CIC0105"
        Quando um Dicente matriculado na turma "CIC0105" acessa o painel de Avaliações
        Então o dicente visualiza o card do formulário dentro do período de vigência
        E o card exibe o nome do template e a data de término

    Cenário: Docente visualiza formulário criado no painel de Avaliações
        Dado que um formulário foi criado para docentes da turma "CIC0105"
        Quando um Docente vinculado à turma "CIC0105" acessa o painel de Avaliações
        Então o docente visualiza o card do formulário dentro do período de vigência
        E o card exibe o nome do template e a data de término

  # ==================== CENÁRIOS TRISTES ====================

    Cenário: Tentativa de criar formulário sem selecionar tipo de destinatário
        Quando deixo o campo de opções "Tipo de Destinatário" em branco
        E seleciono o template "Avaliação Engenharia de Software" no dropdown "Template"
        E seleciono a turma "CIC0105" no campo "Turma(s)"
        E preencho as datas de vigência
        E clico no botão "Criar"
        Então o modal permanece aberto
        E vejo a mensagem de erro "Selecione o tipo de destinatário (Dicentes ou Docentes)"

    Cenário: Tentativa de criar formulário sem selecionar template
        Quando seleciono "Dicentes" no campo "Tipo de Destinatário"
        E não seleciono nenhum template no dropdown "Template"
        E seleciono a turma "CIC0105" no campo "Turma(s)"
        E preencho as datas de vigência
        E clico no botão "Criar"
        Então o modal permanece aberto
        E vejo a mensagem de erro "Selecione um template para o formulário"

    Cenário: Tentativa de criar formulário sem selecionar nenhuma turma
        Quando seleciono "Dicentes" no campo "Tipo de Destinatário"
        E seleciono o template "Avaliação Engenharia de Software" no dropdown "Template"
        E não seleciono nenhuma turma no campo "Turma(s)"
        E preencho as datas de vigência
        E clico no botão "Criar"
        Então o modal permanece aberto
        E vejo a mensagem de erro "Selecione ao menos uma turma"

    Cenário: Tentativa de criar formulário com data de término anterior à data de início
        Quando seleciono "Dicentes" no campo "Tipo de Destinatário"
        E seleciono o template "Avaliação Engenharia de Software" no dropdown "Template"
        E seleciono a turma "CIC0105" no campo "Turma(s)"
        E preencho a data de início com "01/06/2026"
        E preencho a data de término com "26/05/2026"
        E clico no botão "Criar"
        Então o modal permanece aberto
        E vejo a mensagem de erro "A data de término não pode ser anterior à data de início"

    Cenário: Tentativa de criar formulário sem preencher as datas de vigência
        Quando seleciono "Dicentes" no campo "Tipo de Destinatário"
        E seleciono o template "Avaliação Engenharia de Software" no dropdown "Template"
        E seleciono a turma "CIC0105" no campo "Turma(s)"
        E deixo os campos de data em branco
        E clico no botão "Criar"
        Então o modal permanece aberto
        E vejo a mensagem de erro "As datas de vigência são obrigatórias"

    Cenário: Tentativa de acesso à criação de formulários por usuário não administrador
        Dado que estou logado como Dicente
        Quando tento acessar a página "Gerenciamento"
        Então sou redirecionado para o painel do usuário
        E vejo a mensagem de erro "Acesso não autorizado"

    Cenário: Nenhuma turma disponível para criação de formulário
        Dado que não existem turmas cadastradas no sistema
        Quando clico no botão "Criar Formulário"
        Então o modal é exibido
        E o campo "Turma(s)" está vazio
        E vejo a mensagem "Nenhuma turma disponível"
        E o botão "Criar" está desabilitado
