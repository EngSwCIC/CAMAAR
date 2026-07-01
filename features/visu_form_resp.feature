# language: pt

Funcionalidade: Visualizar Formulários Não Respondidos
    Como um Participante de uma turma
    Quero visualizar os formulários não respondidos das turmas em que estou matriculado
    A fim de poder escolher qual irei responder

    Contexto:
        Dado que estou logado como Participante
        E estou matriculado em uma turma com formulário pendente
        E estou na página "Avaliações"
        Então vejo uma seção com os formulários não respondidos das minhas turmas

  # ==================== CENÁRIOS FELIZES ====================

    Cenário: Visualizar lista de formulários não respondidos
        Quando acesso a página "Avaliações"
        Então vejo uma lista com cards de formulários não respondidos
        E cada card exibe "Turma", "Template", "Data de Término" e um botão "Responder"
        E os formulários são agrupados por turma

    Cenário: Visualizar informações completas de um formulário
        Quando clico no card de um formulário
        Então vejo os detalhes completos como "Turma", "Template", "Data de Início", "Data de Término"
        E vejo um botão "Responder Agora"
        E vejo a quantidade de questões do formulário

    #Cenário: Filtrar formulários por turma
    #    Dado que estou matriculado em múltiplas turmas com formulários
    #    Quando seleciono a turma "CIC0105" no filtro
    #    Então a lista exibe apenas os formulários da turma "CIC0105"
    #    E os formulários de outras turmas deixam de aparecer

    #Cenário: Filtrar formulários por tipo de destinatário
    #    Dado que sou um Dicente com formulários para dicentes e também Docente com formulários para docentes
    #    Quando seleciono "Dicentes" no filtro "Tipo de Destinatário"
    #    Então a lista exibe apenas os formulários destinados a dicentes
    #    E os formulários para docentes deixam de aparecer

    #Cenário: Ordenar formulários por data de término
    #    Dado que existem múltiplos formulários com datas diferentes
    #    Quando clico no filtro "Ordenar por"
    #    E seleciono "Data de Término"
    #    Então os formulários aparecem ordenados por data de término (mais próximos primeiro)

    #Cenário: Visualizar tempo restante para responder um formulário
    #    Dado que existe um formulário com deadline em 2 dias
    #    Quando visualizo o card do formulário
    #    Então vejo a mensagem "Tempo restante: 2 dias"
    #    E o card exibe uma barra de progresso de tempo em cor verde

    #Cenário: Visualizar formulário com prazo próximo de vencer
    #    Dado que existe um formulário vencendo em 1 hora
    #    Quando visualizo o card do formulário
    #    Então vejo a mensagem de alerta "Prazo vence em 1 hora"
    #    E o card exibe uma barra de progresso de tempo em cor vermelha

    Cenário: Acessar formulário para responder
        Dado que estou visualizando um formulário não respondido
        Quando clico no botão "Responder Agora"
        Então sou redirecionado para a página de preenchimento do formulário
        E vejo todas as questões do template
        E vejo o botão "Enviar Avaliação"

    #Cenário: Salvar formulário como rascunho
    #    Dado que estou preenchendo um formulário
    #    Quando preencho algumas questões
    #    E clico no botão "Salvar como Rascunho"
    #    Então vejo a mensagem "Formulário salvo como rascunho"
    #    E sou redirecionado para a lista de formulários
    #    E o card do formulário exibe "Rascunho iniciado"

    #Cenário: Continuar preenchimento de um rascunho
    #    Dado que salvei um formulário como rascunho anteriormente
    #    Quando clico no card do formulário
    #    Então vejo o formulário com os dados previamente preenchidos
    #    E vejo um botão "Continuar Preenchimento"
    #    E as respostas anteriores estão mantidas

    #Cenário: Visualizar quantidade de formulários respondidos vs não respondidos
    #    Quando acesso a página "Avaliações"
    #    Então vejo um resumo no topo da página
    #    E vejo a informação "Formulários respondidos: X"
    #    E vejo a informação "Formulários não respondidos: Y"
    #    E vejo um percentual de progresso

    #Cenário: Visualizar abas separadas por status
    #    Quando acesso a página "Avaliações"
    #    Então vejo a aba "Não Respondidos" selecionada por padrão
    #    E vejo a aba "Rascunhos" com formulários salvos como rascunho
    #    E vejo a aba "Respondidos" com formulários já submetidos
    #    E posso clicar para mudar entre abas

  # ==================== CENÁRIOS TRISTES ====================

    #Cenário: Nenhum formulário não respondido disponível
    #    Dado que respondeu todos os formulários das suas turmas
    #    Quando acesso a página "Avaliações"
    #    Então vejo a mensagem "Nenhum formulário não respondido"
    #    E a lista está vazia
    #    E vejo o botão "Ver Respondidos"

    Cenário: Tentar visualizar formulário de turma em que não estou matriculado
        Dado que tentei acessar um formulário através de um link antigo
        Quando abro o link de um formulário da turma "CIC0106" em que não estou matriculado
        Então vejo a mensagem de erro "Você não está matriculado nesta turma"
        E sou redirecionado para a página "Avaliações"

    #Cenário: Formulário expirado não aparece na lista
    #    Dado que existe um formulário com deadline já vencido há 1 dia
    #    Quando acesso a página "Avaliações"
    #    Então o formulário expirado não aparece na lista
    #    E vejo a mensagem "O formulário expirou em 26/05/2026"
    #    E vejo um botão "Ver Formulários Expirados"

    Cenário: Tentativa de responder formulário após o deadline
        Dado que tentei abrir um formulário após seu deadline
        Quando clico no botão "Responder Agora"
        Então vejo a mensagem de erro "Este formulário expirou em 26/05/2026"
        E não consigo acessar o formulário
        E sou redirecionado para a página "Avaliações"

    #Cenário: Erro ao carregar lista de formulários
    #    Quando acesso a página "Avaliações" e o servidor retorna erro
    #    Então vejo a mensagem de erro "Erro ao carregar os formulários"
    #    E vejo um botão "Tentar Novamente"
    #    E nenhum formulário é exibido

    #Cenário: Sem conexão ao tentar abrir formulário
    #    Dado que cliquei em um formulário para responder
    #    Quando a conexão com o servidor é perdida
    #    Então vejo a mensagem "Erro de conexão. Verifique sua internet"
    #    E o botão "Tentar Novamente" é exibido

    #Cenário: Formulário foi deletado enquanto visualizava
    #    Dado que estava visualizando os detalhes de um formulário
    #    Quando o administrador deleta o formulário
    #    E atualizo a página
    #    Então vejo a mensagem "Este formulário não existe mais"
    #    E o formulário é removido da lista

    #Cenário: Perda de dados ao fechar formulário sem salvar
    #    Dado que estava preenchendo um formulário
    #    Quando fecho a aba do navegador sem clicar em "Salvar como Rascunho"
    #    E abro novamente o formulário
    #    Então vejo a mensagem "Seus dados não foram salvos"
    #    E o formulário começa vazio novamente

    #Cenário: Erro ao salvar formulário como rascunho
    #    Dado que estou preenchendo um formulário
    #    Quando clico em "Salvar como Rascunho" e o servidor retorna erro
    #    Então vejo a mensagem de erro "Erro ao salvar como rascunho. Tente novamente"
    #    E permaneço na página de preenchimento
    #    E meus dados continuam no formulário

    #Cenário: Limite de rascunhos atingido
    #    Dado que salvei 10 formulários como rascunho
    #    Quando tento salvar outro formulário como rascunho
    #    Então vejo a mensagem "Limite de rascunhos atingido (máximo 10)"
    #    E preciso deletar um rascunho anterior
    #    E o formulário não é salvo

    Cenário: Sem permissão para responder formulário
        Dado que sou um Dicente
        Quando um formulário é enviado especificamente para Docentes
        Então esse formulário não aparece na minha lista de não respondidos
        E não consigo acessá-lo mesmo tendo o link direto
