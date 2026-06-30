# language: pt

Funcionalidade: Sistema de gerenciamento por departamento
    Eu como Administrador
    Quero gerenciar somente as turmas do departamento o qual eu pertenço
    A fim de avaliar o desempenho das turmas no semestre atual

    Contexto:
        Dado que os dados do SIGAA para o semestre atual "2026.1" foram sincronizados
        E existem turmas cadastradas para o departamento "Ciência da Computação (CIC)"
        E existem turmas cadastradas para o departamento "Matemática (MAT)"
        E existe um usuário "Admin_CIC" autenticado com perfil de "Administrador"
        E o usuário "Admin_CIC" está vinculado institucionalmente ao departamento "Ciência da Computação (CIC)"

    @cenario_feliz
    Cenário: Visualização da listagem de turmas restrita ao próprio departamento (Caminho Feliz)
        Dado que o "Admin_CIC" acessa o painel de gerenciamento de turmas do semestre atual
        Quando a listagem de turmas for carregada na tela
        Então ele deve visualizar as disciplinas referentes ao departamento "Ciência da Computação (CIC)", como "Engenharia de Software"
        E a lista não deve exibir nenhuma disciplina referente ao departamento "Matemática (MAT)", como "Cálculo 1"

    @cenario_feliz
    Cenário: Avaliação de desempenho restrita às turmas do departamento (Caminho Feliz)
        Dado que o "Admin_CIC" acessa a página de "Desempenho Semestral"
        Quando ele solicita a geração do relatório consolidado de turmas do semestre "2026.1"
        Então o sistema deve compilar os dados
        E o relatório gerado deve conter exclusivamente as métricas de avaliação das turmas vinculadas ao "Ciência da Computação (CIC)"
        E os dados consolidados não devem sofrer interferência de notas ou respostas de turmas de outros departamentos

    @cenario_triste
    Cenário: Tentativa de acesso direto a uma turma de outro departamento via URL (Fluxo de Segurança)
        Dado que a turma de "Cálculo 1" pertence ao departamento "Matemática (MAT)" e possui o ID de sistema "999"
        Quando o "Admin_CIC" tenta forçar o acesso digitando diretamente a URL "/admin/turmas/999/avaliacoes"
        Então o sistema deve interceptar a requisição e bloquear o acesso
        E deve redirecionar o usuário para o painel principal do seu departamento
        E exibir a mensagem de erro "Acesso negado: Você tem permissão para gerenciar apenas as turmas vinculadas ao seu departamento."

    @cenario_triste
    Cenário: Departamento sem turmas sincronizadas no semestre atual (Cenário Triste)
        Dado que o "Admin_CIC" acessa o painel de gerenciamento de turmas do semestre atual
        Mas a sincronização com o SIGAA não retornou nenhuma turma ativa para o departamento "Ciência da Computação (CIC)" no semestre "2026.1"
        Então a listagem de turmas deve aparecer vazia
        E o sistema deve exibir a mensagem de aviso "Nenhuma turma encontrada para o seu departamento neste semestre. Verifique o status da sincronização com o SIGAA."
        E o botão "Gerar Relatório de Desempenho" deve estar desabilitado