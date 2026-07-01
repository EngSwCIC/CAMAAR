# language: pt

@javascript
Funcionalidade: Gerar formulário de avaliação
    Como um Administrador
    Quero criar um formulário baseado em um template para as turmas que eu escolher
    A fim de avaliar o desempenho das turmas no semestre atual

    Contexto:
        Dado que existem turmas e templates para criação de formulários
        E que estou logado como Administrador
        E estou na página "Gerenciamento"
        E clico no botão "Criar Formulário"
        Então um modal é exibido com os campos "Tipo de Destinatário", "Template", "Turma(s)" e data de disponibilidade

  # ==================== CENÁRIOS FELIZES ====================

    Cenário: Visualizar modal de criação de formulário com turmas disponíveis
        Então o modal exibe o campo "Template" com um dropdown
        E o modal exibe o campo "Turma(s)" com um seletor de múltipla escolha
        E vejo o botão "Criar"

    Cenário: Enviar formulário para uma turma selecionada
        Quando seleciono "Dicentes" no campo "Tipo de Destinatário"
        E seleciono o template "Avaliação Engenharia de Software" no dropdown "Template"
        E seleciono a turma "CIC0105" no campo "Turma(s)"
        E preencho a data de início com "26/05/2026"
        E preencho a data de término com "01/06/2026"
        E clico no botão "Criar"
        Então o modal é fechado
        E vejo a mensagem de sucesso "Formulário criado com sucesso para dicentes"
        E o formulário fica disponível para os discentes da turma "CIC0105"

    Cenário: Enviar formulário para múltiplas turmas simultaneamente
        Quando seleciono "Dicentes" no campo "Tipo de Destinatário"
        E seleciono o template "Avaliação Engenharia de Software" no dropdown "Template"
        E seleciono a turma "CIC0105" no campo "Turma(s)"
        E seleciono a turma "CIC0202" no campo "Turma(s)"
        E preencho a data de início com "26/05/2026"
        E preencho a data de término com "01/06/2026"
        E clico no botão "Criar"
        Então o modal é fechado
        E vejo a mensagem de sucesso "Formulário criado com sucesso para 2 turmas"
        E o formulário fica disponível para os discentes das duas turmas selecionadas

    Cenário: Formulário enviado aparece disponível para os discentes da turma
        Dado que o formulário baseado no template "Avaliação Engenharia de Software" foi enviado para a turma "CIC0105"
        Quando um Discente matriculado na turma "CIC0105" acessa o painel de Avaliações
        Então o discente visualiza o card da turma "CIC0105" disponível para resposta

    Cenário: Discente responde o formulário enviado pelo administrador
        Dado que o formulário foi enviado para a turma "CIC0105"
        E o Discente acessou o card da turma "CIC0105"
        Quando o Discente responde as questões exibidas e clica no botão de envio
        Então a resposta é registrada no sistema
        E o resultado fica disponível na tela "Gerenciamento - Resultados" do Administrador

  # ==================== CENÁRIOS TRISTES ====================

    Cenário: Tentativa de enviar formulário sem selecionar um template
        Quando seleciono "Dicentes" no campo "Tipo de Destinatário"
        E não seleciono nenhum template no dropdown "Template"
        E seleciono a turma "CIC0105" no campo "Turma(s)"
        E preencho as datas de vigência
        E clico no botão "Criar"
        Então o modal permanece aberto
        E vejo a mensagem de erro "Selecione um template para o formulário"

    Cenário: Tentativa de enviar formulário sem selecionar nenhuma turma
        Quando seleciono "Dicentes" no campo "Tipo de Destinatário"
        E seleciono o template "Avaliação Engenharia de Software" no dropdown "Template"
        E não seleciono nenhuma turma no campo "Turma(s)"
        E preencho as datas de vigência
        E clico no botão "Criar"
        Então o modal permanece aberto
        E vejo a mensagem de erro "Selecione ao menos uma turma"

    Cenário: Nenhuma turma cadastrada exibida no campo do modal
        Dado que não existem turmas cadastradas no sistema
        Quando clico no botão "Criar Formulário"
        Então o modal é exibido
        E o campo "Turma(s)" está vazio
        E vejo a mensagem "Nenhuma turma disponível"
        E o botão "Criar" está desabilitado

    Cenário: Tentativa de acesso à criação de formulários por usuário não administrador
        Dado que estou logado como Discente
        Quando tento acessar a página "Gerenciamento"
        Então sou redirecionado para o painel do usuário
        E vejo a mensagem de erro "Acesso não autorizado"
