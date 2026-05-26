#language: pt

Funcionalidade: Gerar relatório do Administrador
    Como um Administrador
    Quero baixar um arquivo CSV contendo os resultados de um formulário
    A fim de avaliar o desempenho das turmas

    Contexto:
        Dado que estou logado como Administrador
        E estou na página "Gerenciamento"
        E clico no botão "Resultados"
    
  # ==================== CENÁRIOS FELIZES ====================

    Cenário: Visualizar listagem de turmas com resultados disponíveis
        Então vejo uma listagem de cards com turmas
        E cada card exibe o "Nome da matéria", o "semestre" e o "Professor"

    Cenário: Download do CSV com resultados de uma turma
        Dado que a turma "Engenharia de Software - 2026.1 - Prof. Genaina" possui respostas registradas
        Quando clico no card da turma "Engenharia de Software - 2026.1 - Prof. Genaina"
        E clico no botão "Baixar CSV"
        Então um arquivo CSV é baixado com os resultados da turma selecionada
        E o arquivo contém as colunas "Turma", "Discente", "Questão" e "Resposta"
        E cada linha corresponde a uma resposta submetida por um discente

    Cenário: Download do CSV contendo todos os tipos de resposta do formulário
        Dado que a turma "Engenharia de Software - 2026.1 - Prof. Genaina" possui respostas de questões do tipo Radio e Texto
        Quando clico no card da turma "Engenharia de Software - 2026.1 - Prof. Genaina"
        E clico no botão "Baixar CSV"
        Então o arquivo CSV baixado contém uma coluna para cada questão do formulário
        E os valores correspondem às respostas selecionadas ou digitadas pelos discentes

  # ==================== CENÁRIOS TRISTES ====================

    Cenário: Tentativa de download de CSV de turma sem respostas registradas
        Dado que a turma "Software Básico - 2026.1 - Prof. Ladeira" não possui nenhuma resposta registrada
        Quando clico no card da turma "Software Básico - 2026.1 - Prof. Ladeira"
        E clico no botão "Baixar CSV"
        Então nenhum arquivo é baixado
        E vejo a mensagem de aviso "Esta turma ainda não possui respostas registradas"

    Cenário: Nenhuma turma disponível na tela de Resultados
        Dado que nenhum formulário foi enviado para nenhuma turma
        Quando acesso "Gerenciamento - Resultados"
        Então vejo a mensagem "Nenhum resultado disponível"
        E nenhum card de turma é exibido

    Cenário: Tentativa de acesso à tela de Resultados por usuário não administrador
        Dado que estou logado como Discente
        Quando tento acessar a página "Gerenciamento - Resultados"
        Então sou redirecionado para o painel do usuário
        E vejo a mensagem de erro "Acesso não autorizado"
