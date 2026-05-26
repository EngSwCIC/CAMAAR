# language: pt

Funcionalidade: Visualizar Resultados de Formulários
    Como um Administrador
    Quero visualizar os formulários criados
    A fim de poder gerar um relatório a partir das respostas

    Contexto:
        Dado que estou logado como Administrador
        E estou na página "Gerenciamento"
        E clico no botão "Resultados"
        Então sou redirecionado para a página "Gerenciamento - Resultados"
        E vejo uma tabela com os formulários enviados

  # ==================== CENÁRIOS FELIZES ====================

    Cenário: Visualizar tabela de formulários com todas as informações
        Quando acesso a página "Gerenciamento - Resultados"
        Então vejo uma tabela com as colunas "Template", "Turma", "Destinatário", "Respostas Recebidas" e "Status"
        E cada linha exibe as informações do formulário enviado
        E vejo o botão "Ver Detalhes" em cada linha

    Cenário: Visualizar detalhes de um formulário com respostas recebidas
        Dado que existem formulários com respostas já registradas
        Quando clico no botão "Ver Detalhes" de um formulário
        Então um modal é exibido com o nome do template
        E vejo a quantidade total de respostas recebidas
        E vejo as questões do formulário com o resumo das respostas
        E as questões do tipo "Radio" exibem um gráfico com as opções e seus percentuais
        E as questões do tipo "Texto" exibem as respostas em formato de lista

    Cenário: Visualizar gráfico de respostas para questão do tipo Radio
        Dado que abri os detalhes de um formulário com questões do tipo Radio
        Quando visualizo a questão "Como você avalia a didática do professor?"
        Então vejo um gráfico com as opções e seus respectivos percentuais
        E a barra com maior percentual é destacada com uma cor diferente

    Cenário: Visualizar respostas para questão do tipo Texto
        Dado que abri os detalhes de um formulário com questões do tipo Texto
        Quando visualizo a questão "Deixe seu comentário sobre o professor"
        Então vejo uma lista com todas as respostas recebidas
        E cada resposta exibe o nome do respondente e a data de envio

    Cenário: Filtrar formulários por turma
        Dado que existem formulários de múltiplas turmas
        Quando seleciono a turma "CIC0105" no filtro
        Então a tabela exibe apenas os formulários da turma "CIC0105"
        E a quantidade de linhas é reduzida

    Cenário: Filtrar formulários por tipo de destinatário
        Dado que existem formulários para dicentes e docentes
        Quando seleciono "Dicentes" no filtro "Tipo de Destinatário"
        Então a tabela exibe apenas os formulários destinados a dicentes
        E os formulários para docentes deixam de aparecer

    Cenário: Filtrar formulários por período
        Dado que existem formulários de períodos diferentes
        Quando seleciono a data de início "01/05/2026" no filtro "Data de Início"
        E seleciono a data de término "31/05/2026" no filtro "Data de Término"
        Então a tabela exibe apenas os formulários dentro do período selecionado

    Cenário: Exportar dados de um formulário em formato CSV
        Dado que abri os detalhes de um formulário
        Quando clico no botão "Exportar CSV"
        Então um arquivo com as respostas do formulário é baixado
        E o arquivo contém todas as questões e respostas em formato CSV

    Cenário: Exportar dados de um formulário em formato PDF
        Dado que abri os detalhes de um formulário
        Quando clico no botão "Exportar PDF"
        Então um arquivo com as respostas do formulário é baixado em formato PDF
        E o PDF contém um relatório formatado com gráficos e respostas de texto

    Cenário: Visualizar formulário sem respostas ainda recebidas
        Dado que existe um formulário criado recentemente sem respostas
        Quando clico em "Ver Detalhes" do formulário
        Então o modal exibe a mensagem "Nenhuma resposta recebida ainda"
        E não vejo questões nem gráficos
        E vejo o botão "Voltar"

    Cenário: Ordenar tabela por coluna "Respostas Recebidas"
        Dado que existem múltiplos formulários com quantidades diferentes de respostas
        Quando clico no cabeçalho da coluna "Respostas Recebidas"
        Então a tabela é ordenada em ordem decrescente de respostas
        Quando clico novamente no cabeçalho
        Então a tabela é ordenada em ordem crescente

  # ==================== CENÁRIOS TRISTES ====================

    Cenário: Tentativa de acesso à visualização de resultados por usuário não administrador
        Dado que estou logado como Dicente
        Quando tento acessar a página "Gerenciamento - Resultados"
        Então sou redirecionado para o painel do usuário
        E vejo a mensagem de erro "Acesso não autorizado"

    Cenário: Nenhum formulário enviado no sistema
        Dado que nenhum formulário foi criado ou enviado
        Quando acesso a página "Gerenciamento - Resultados"
        Então a tabela está vazia
        E vejo a mensagem "Nenhum formulário enviado ainda"
        E o botão "Ver Detalhes" não está disponível

    Cenário: Tentativa de exportar formulário sem permissão
        Dado que sou um Docente
        Quando abro os detalhes de um formulário respondido por seus alunos
        Então não vejo os botões "Exportar CSV" ou "Exportar PDF"
        E vejo a mensagem "Você não tem permissão para exportar este formulário"

    Cenário: Tentativa de acessar detalhes de um formulário deletado
        Dado que um formulário foi deletado do sistema
        Quando tento acessar os detalhes deste formulário através de um link antigo
        Então vejo a mensagem de erro "Este formulário não existe mais"
        E sou redirecionado para a página "Gerenciamento - Resultados"

    Cenário: Filtrar com período inválido
        Quando seleciono a data de início "31/05/2026" no filtro "Data de Início"
        E seleciono a data de término "01/05/2026" no filtro "Data de Término"
        E clico no botão "Filtrar"
        Então a tabela permanece sem aplicar o filtro
        E vejo a mensagem de erro "A data de término não pode ser anterior à data de início"

    Cenário: Gráfico não carrega corretamente para formulário com muitas respostas
        Dado que existe um formulário com mais de 1000 respostas
        Quando abro os detalhes deste formulário
        Então o gráfico não é exibido
        E vejo a mensagem "Muitas respostas. Use a exportação em CSV para análise detalhada"

    Cenário: Falha na exportação de arquivo
        Dado que abri os detalhes de um formulário
        Quando clico no botão "Exportar CSV" e a exportação falha
        Então vejo a mensagem de erro "Erro ao exportar. Tente novamente"
        E o arquivo não é baixado
