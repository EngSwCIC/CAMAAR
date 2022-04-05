#language: pt
Funcionalidade: Permitir o professor filtrar as respostas por turma
    Como um professor
    Eu quero filtrar os resultados de uma pergunta por turma
    Para que eu consiga analisar as respostas de um formulário aplicado numa turma específica

    # Caminho feliz
    Contexto: Gerar visualização filtrada por turma
        Dado que eu esteja na página principal de visualização das respostas dos formulários
        E eu tenha selecionado um formulário
        Entao a aplicação deveria me mostrar a opção para filtrar por turma
        E eu tendo selecionado uma turma
        Entao eu deveria ver o resultado daquele formulário filtrado pela turma selecionada

    # Caminho feliz
    Contexto: Erro na comunicação com o banco de dados
        Dado que eu esteja na página principal de visualização das respostas dos formulários
        E eu tenha selecionado um formulário
        E a aplicação falha em buscar mas turmas disponíveis para aquela questão
        Entao a aplicação deveria mostrar uma mensagem de erro para o usuário no lugar do relatório

    # Caminho triste
    Contexto: A questão existe na turma mas nenhum aluno respondeu
        Dado que eu esteja na página principal de visualização das respostas dos formulários
        E eu tenha selecionado um formulário
        E a aplicação retorna um relatório vazio do banco de dados
        Entao a aplicação deveria mostrar um alerta para o usuário e nao gerar um relatório
