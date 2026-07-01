# language: pt

Funcionalidade: Importar dados do SIGAA
    Como Administrador
    Quero importar dados de turmas, matérias e participantes do SIGAA
    A fim de alimentar a base de dados do sistema

    Contexto:
        Dado que estou logado como Administrador
        Dado que acesso a página "Gerenciamento - Importar Dados"

  # ==================== CENÁRIOS FELIZES ====================

    Cenário: Importação de dados de turmas inéditas com sucesso
        Quando seleciono o arquivo "classes.json" para importar do SIGAA
        E clico no botão de ação de importação "Confirmar Importação"
        Então vejo a mensagem de sucesso da importação "Dados de turmas importados com sucesso: 3 novas turmas processadas"
        E a disciplina "ENGENHARIA DE SOFTWARE" passa a ser listada no sistema

    Cenário: Importação de participantes da turma com sucesso
        Quando seleciono o arquivo "class_members.json" para importar do SIGAA
        E clico no botão de ação de importação "Confirmar Importação"
        Então vejo a mensagem de sucesso da importação "Participantes importados com sucesso"
        E a lista de discentes da turma exibe o aluno "Ana Clara Jordao Perna"

  # ==================== CENÁRIOS TRISTES ====================
    Cenário: Tentativa de importar arquivo com formato inválido
        Quando seleciono o arquivo "relatorio.pdf" para importar do SIGAA
        E clico no botão de ação de importação "Confirmar Importação"
        Então vejo a mensagem de erro da importação "Formato de arquivo inválido. Por favor, envie um arquivo .json"
        E o sistema não realiza nenhuma alteração na base de dados

    Cenário: Importar arquivo JSON com estrutura corrompida
        Dado que possuo um arquivo "corrompido.json" com chaves faltando
        Quando seleciono o arquivo "corrompido.json" para importar do SIGAA
        E clico no botão de ação de importação "Confirmar Importação"
        Então vejo a mensagem de erro da importação "Erro na estrutura do arquivo: campos obrigatórios ausentes"

    Cenário: Tentativa de importação sem selecionar nenhum arquivo
        Quando clico no botão de ação de importação "Confirmar Importação" sem selecionar um arquivo
        Então vejo o alerta da importação "Por favor, selecione um arquivo para importar"
        E permaneço na página de importação
