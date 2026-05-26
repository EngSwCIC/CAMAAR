# language: pt

Funcionalidade: Gerenciamento de Turmas por Departamento
    Como um Administrador
    Quero gerenciar somente as turmas do departamento o qual eu pertenço
    A fim de avaliar o desempenho das turmas no semestre atual

    Contexto:
        Dado que estou logado como Administrador do departamento "CIC"
        E estou na página "Gerenciamento"
        E clico no botão "Turmas"
        Então sou redirecionado para a página "Gerenciamento - Turmas"
        E vejo uma tabela com as turmas do departamento "CIC"

  # ==================== CENÁRIOS FELIZES ====================

    Cenário: Visualizar turmas do próprio departamento
        Quando acesso a página "Gerenciamento - Turmas"
        Então vejo a tabela com colunas "Código", "Nome", "Semestre", "Docente" e "Status"
        E vejo apenas turmas que pertencem ao departamento "CIC"
        E turmas de outros departamentos não aparecem na tabela

    Cenário: Visualizar detalhes de uma turma do departamento
        Dado que existe a turma "CIC0105" no departamento "CIC"
        Quando clico na turma "CIC0105"
        Então sou redirecionado para a página de detalhes da turma
        E vejo informações como "Código", "Nome", "Docente", "Semestre", "Horário" e "Sala"
        E vejo o botão "Editar Turma"

    Cenário: Editar informações de uma turma do departamento
        Dado que estou visualizando os detalhes da turma "CIC0105"
        Quando clico no botão "Editar Turma"
        Então um formulário é exibido com os dados atuais da turma
        Quando altero o campo "Sala" para "Sala 101"
        E clico no botão "Salvar"
        Então vejo a mensagem de sucesso "Turma atualizada com sucesso"
        E a turma "CIC0105" agora exibe "Sala 101"

    Cenário: Visualizar lista de dicentes de uma turma
        Dado que estou na página de detalhes da turma "CIC0105"
        Quando clico no botão "Ver Dicentes"
        Então um modal é exibido com a lista de dicentes matriculados
        E vejo colunas "Matrícula", "Nome", "Email" e "Status de Respostas"
        E cada dicente mostra se respondeu formulários ou não

    Cenário: Visualizar lista de docentes de uma turma
        Dado que estou na página de detalhes da turma "CIC0105"
        Quando clico no botão "Ver Docentes"
        Então um modal é exibido com a lista de docentes vinculados
        E vejo colunas "Matrícula", "Nome", "Email" e "Especialidade"

    Cenário: Visualizar estatísticas de respostas de uma turma
        Dado que existem formulários enviados para a turma "CIC0105"
        Quando clico no botão "Estatísticas"
        Então vejo um painel com gráficos de desempenho
        E vejo a taxa de resposta dos dicentes em percentual
        E vejo a taxa de resposta dos docentes em percentual
        E vejo a data da última resposta recebida

    Cenário: Filtrar turmas por semestre
        Dado que existem turmas de semestres diferentes no departamento
        Quando seleciono o semestre "2026.1" no filtro
        Então a tabela exibe apenas as turmas do semestre "2026.1"

    Cenário: Filtrar turmas por docente
        Dado que existem turmas de diferentes docentes
        Quando seleciono o docente "Prof. João" no filtro
        Então a tabela exibe apenas as turmas lecionadas por "Prof. João"

    Cenário: Filtrar turmas por status
        Dado que existem turmas com status "Ativa" e "Encerrada"
        Quando seleciono "Ativa" no filtro "Status"
        Então a tabela exibe apenas as turmas ativas
        E as turmas encerradas deixam de aparecer

    Cenário: Ordenar tabela de turmas por coluna
        Quando clico no cabeçalho da coluna "Nome"
        Então a tabela é ordenada alfabeticamente por nome
        Quando clico novamente
        Então a tabela é ordenada em ordem reversa

    Cenário: Acessar painel de relatório de uma turma
        Dado que estou visualizando os detalhes da turma "CIC0105"
        Quando clico no botão "Gerar Relatório"
        Então um modal de seleção de filtros é exibido
        E vejo opções para selecionar "Tipo de Relatório", "Período" e "Formato"
        E clico no botão "Gerar"

  # ==================== CENÁRIOS TRISTES ====================

    Cenário: Tentativa de acesso ao gerenciamento de turmas por usuário não administrador
        Dado que estou logado como Dicente
        Quando tento acessar a página "Gerenciamento - Turmas"
        Então sou redirecionado para o painel do usuário
        E vejo a mensagem de erro "Acesso não autorizado"

    Cenário: Tentativa de gerenciar turma de outro departamento
        Dado que sou um Administrador do departamento "CIC"
        Quando tento acessar a página de edição da turma "ENG0150" que pertence ao departamento "ENG"
        Então vejo a mensagem de erro "Você não tem permissão para gerenciar esta turma"
        E sou redirecionado para a página "Gerenciamento - Turmas"

    Cenário: Nenhuma turma disponível para o departamento
        Dado que sou um Administrador de um departamento sem turmas cadastradas
        Quando acesso a página "Gerenciamento - Turmas"
        Então a tabela está vazia
        E vejo a mensagem "Nenhuma turma disponível no seu departamento"

    Cenário: Tentativa de editar turma sem preencher campo obrigatório
        Dado que estou no formulário de edição da turma "CIC0105"
        Quando limpo o campo "Sala"
        E clico no botão "Salvar"
        Então o formulário permanece aberto
        E vejo a mensagem de erro "O campo 'Sala' é obrigatório"

    Cenário: Tentativa de editar turma com horário inválido
        Dado que estou no formulário de edição da turma "CIC0105"
        Quando altero o campo "Horário" para "99:99"
        E clico no botão "Salvar"
        Então vejo a mensagem de erro "Horário inválido"
        E a turma não é atualizada

    Cenário: Tentativa de visualizar dicentes sem conexão com o sistema
        Dado que estou na página de detalhes da turma "CIC0105"
        E a conexão com o servidor foi perdida
        Quando clico no botão "Ver Dicentes"
        Então vejo a mensagem de erro "Erro ao carregar dicentes. Verifique sua conexão"

    Cenário: Lista de dicentes vazia
        Dado que a turma "CIC0105" não possui nenhum dicente matriculado
        Quando clico no botão "Ver Dicentes"
        Então o modal exibe a mensagem "Nenhum dicente matriculado nesta turma"

    Cenário: Gerar relatório com período inválido
        Dado que estou no modal de geração de relatório
        Quando seleciono a data de início "31/05/2026"
        E seleciono a data de término "01/05/2026"
        E clico no botão "Gerar"
        Então o modal permanece aberto
        E vejo a mensagem de erro "A data de término não pode ser anterior à data de início"

    Cenário: Falha ao gerar relatório
        Dado que estou no modal de geração de relatório
        Quando seleciono todos os filtros corretamente
        E clico no botão "Gerar" e o servidor retorna erro
        Então vejo a mensagem de erro "Erro ao gerar relatório. Tente novamente"
        E o arquivo não é gerado

    Cenário: Administrador removido do departamento não consegue acessar turmas
        Dado que minha vinculação com o departamento "CIC" foi removida
        Quando tento acessar a página "Gerenciamento - Turmas"
        Então vejo a mensagem de erro "Você não está vinculado a nenhum departamento"
        E sou redirecionado para o painel de login
