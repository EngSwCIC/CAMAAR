# language: pt

Funcionalidade: Gerar relatório do administrador
    Eu como Administrador
    Quero baixar um arquivo CSV contendo os resultados de um formulário
    A fim de avaliar o desempenho das turmas

    Contexto:
        Dado que existe um usuário com o perfil "Administrador" autenticado no sistema CAMAAR
        E que os dados de turmas e disciplinas do SIGAA do semestre "2023.2" foram sincronizados
        E existe um formulário de avaliação chamado "Avaliação Remota CIC 2023.2"

    @cenario_feliz
    Cenário: Exportação de relatório CSV com sucesso (Caminho Feliz)
        Dado que o formulário "Avaliação Remota CIC 2023.2" possui respostas cadastradas pelos alunos
        E o administrador acessa a página de "Relatórios de Avaliação"
        Quando ele seleciona o formulário "Avaliação Remota CIC 2023.2" na listagem
        E clica no botão "Exportar Resultados (CSV)"
        Então o sistema deve iniciar o download de um arquivo chamado "resultados_avaliacao_remota_cic_2023_2.csv"
        E o arquivo CSV baixado deve conter as colunas "Matrícula", "Turma", "Disciplina" e "Respostas"
        E o sistema deve exibir a mensagem de sucesso "Relatório gerado com sucesso."

    @cenario_feliz
    Cenário: Filtro de exportação por turma específica (Fluxo Alternativo)
        Dado que o formulário "Avaliação Remota CIC 2023.2" possui respostas para as turmas "A" e "B" de "Cálculo 1"
        E o administrador acessa a página de "Relatórios de Avaliação"
        E seleciona o formulário "Avaliação Remota CIC 2023.2"
        Quando ele filtra os resultados escolhendo apenas a turma "A"
        E clica no botão "Exportar Resultados (CSV)"
        Então o arquivo baixado deve conter apenas as respostas dos alunos matriculados na turma "A" de "Cálculo 1"


    @cenario_triste
    Cenário: Tentativa de exportar relatório de um formulário sem respostas (Fluxo de Exceção)
        Dado que foi criado um novo formulário chamado "Avaliação Remota CIC 2024.1"
        E o formulário "Avaliação Remota CIC 2024.1" ainda não possui nenhuma resposta
        E o administrador acessa a página de "Relatórios de Avaliação"
        Quando ele seleciona o formulário "Avaliação Remota CIC 2024.1" na listagem
        E clica no botão "Exportar Resultados (CSV)"
        Então o sistema não deve iniciar nenhum download de arquivo
        E deve exibir a mensagem de aviso "Não há dados suficientes para gerar o relatório desta avaliação."


    @cenario_triste
    Cenário: Bloqueio de geração de relatório para usuários sem permissão administrativa (Segurança)
        Dado que existe um usuário com o perfil "Docente" autenticado no sistema CAMAAR
        Quando ele tenta acessar a URL direta de geração de relatórios administrativos em "/admin/relatorios/csv"
        Então o sistema deve redirecioná-lo para a página inicial
        E deve exibir a mensagem de erro "Acesso negado. Apenas administradores podem gerar este relatório."