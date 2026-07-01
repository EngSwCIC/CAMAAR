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

  # ==================== CENÁRIOS FELIZES ====================

    Cenário: Visualizar resumo de um formulário com respostas registradas
        Dado que a turma "Engenharia de Software - 2026.1 - Prof. Genaina" possui respostas de questões do tipo Radio e Texto
        Quando clico no card da turma "Engenharia de Software - 2026.1 - Prof. Genaina"
        Então vejo o nome do template do formulário
        E vejo a quantidade total de respostas recebidas
        E vejo um resumo para cada questão do formulário

    Cenário: Visualizar resumo de questão do tipo Radio
        Dado que a turma "Engenharia de Software - 2026.1 - Prof. Genaina" possui respostas de questões do tipo Radio e Texto
        Quando clico no card da turma "Engenharia de Software - 2026.1 - Prof. Genaina"
        Então a questão do tipo "Radio" exibe a quantidade de respostas recebidas para cada opção

    Cenário: Visualizar resumo de questão do tipo Texto
        Dado que a turma "Engenharia de Software - 2026.1 - Prof. Genaina" possui respostas de questões do tipo Radio e Texto
        Quando clico no card da turma "Engenharia de Software - 2026.1 - Prof. Genaina"
        Então a questão do tipo "Texto" exibe a lista com todas as respostas recebidas

  # ==================== CENÁRIOS TRISTES ====================

    Cenário: Visualizar formulário de turma sem respostas registradas
        Dado que a turma "Software Básico - 2026.1 - Prof. Ladeira" não possui nenhuma resposta registrada
        Quando clico no card da turma "Software Básico - 2026.1 - Prof. Ladeira"
        Então vejo a mensagem "Esta turma ainda não possui respostas registradas"
        E não vejo nenhum resumo de questão

    Cenário: Tentativa de acesso à tela de Resultados por usuário não administrador
        Dado que estou logado como Discente
        Quando tento acessar a página "Gerenciamento - Resultados"
        Então sou redirecionado para o painel do usuário
        E vejo a mensagem de erro "Acesso não autorizado"
