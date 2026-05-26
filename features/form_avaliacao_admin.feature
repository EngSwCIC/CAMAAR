# language: pt

Funcionalidade: Gerar formulário de avaliação
    Como um Administrador
    Quero criar um formulário baseado em um template para as turmas que eu escolher
    A fim de avaliar o desempenho das turmas no semestre atual

    Contexto:
        Dado que estou logado como Administrador
        E estou na página "Gerenciamento"
        E clico no botão "Enviar Formulários"
        Então um modal é exibido com um dropdown de "Template" e uma tabela de turmas

  # ==================== CENÁRIOS FELIZES ====================

    Cenário: Visualizar modal de envio de formulário com turmas disponíveis
        Então o modal exibe o campo "Template" com um dropdown
        E o modal exibe uma tabela com as colunas "Nome", "Semestre" e "Código"
        E cada linha da tabela possui um checkbox para seleção
        E vejo o botão "Enviar"

    Cenário: Enviar formulário para uma turma selecionada
        Dado que existem turmas cadastradas no sistema
        Quando seleciono o template "Avaliação Engenharia de Software" no dropdown "Template"
        E marco o checkbox da turma "Estudos Em" com semestre "2026.1" e código "CIC0105"
        E clico no botão "Enviar"
        Então o modal é fechado
        E vejo a mensagem de sucesso "Formulário enviado com sucesso"
        E o formulário fica disponível para os discentes da turma "CIC0105"

    Cenário: Enviar formulário para múltiplas turmas simultaneamente
        Dado que existem ao menos duas turmas cadastradas no sistema
        Quando seleciono o template "Avaliação Engenharia de Software" no dropdown "Template"
        E marco o checkbox da turma "Estudos Em" com semestre "2026.1" e código "CIC0105"
        E marco o checkbox da segunda turma "Estudos Em" com semestre "2026.1" e código "CIC0106"
        E clico no botão "Enviar"
        Então o modal é fechado
        E vejo a mensagem de sucesso "Formulário enviado com sucesso"
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
        Dado que existem turmas cadastradas no sistema
        Quando não seleciono nenhum template no dropdown "Template"
        E marco o checkbox de uma turma na tabela
        E clico no botão "Enviar"
        Então o modal permanece aberto
        E vejo a mensagem de erro "Selecione um template para o formulário"

    Cenário: Tentativa de enviar formulário sem selecionar nenhuma turma
        Quando seleciono o template "Avaliação Engenharia de Software" no dropdown "Template"
        E não marco o checkbox de nenhuma turma na tabela
        E clico no botão "Enviar"
        Então o modal permanece aberto
        E vejo a mensagem de erro "Selecione ao menos uma turma"

    Cenário: Nenhuma turma cadastrada exibida na tabela do modal
        Dado que não existem turmas cadastradas no sistema
        Quando o modal de "Enviar Formulários" é aberto
        Então a tabela de turmas está vazia
        E vejo a mensagem "Nenhuma turma disponível"
        E o botão "Enviar" está desabilitado

    Cenário: Tentativa de acesso ao envio de formulários por usuário não administrador
        Dado que estou logado como Discente
        Quando tento acessar a página "Gerenciamento"
        Então sou redirecionado para o painel do usuário
        E vejo a mensagem de erro "Acesso não autorizado"
