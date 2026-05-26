# language: pt

Funcionalidade: Importar dados do SIGAA
    Como Administrador
    Quero importar dados de turmas, matérias e participantes do SIGAA
    A fim de alimentar a base de dados do sistema

    Contexto:
        Dado que estou logado como Administrador
        E estou na página "Gerenciamento - Importar Dados"

  # ==================== CENÁRIOS FELIZES ====================

    Cenário: Importação de dados de turmas inéditas com sucesso
        Quando clico no botão "Selecionar Arquivo"
        E seleciono o arquivo "classes.json"
        E clico no botão "Confirmar Importação"
        Então vejo a mensagem de sucesso "Dados de turmas importados com sucesso: 3 novas turmas adicionadas"
        E a disciplina "ENGENHARIA DE SOFTWARE" passa a ser listada no sistema

    Cenário: Importação de participantes da turma com sucesso
        Quando clico no botão "Selecionar Arquivo"
        E seleciono o arquivo "class_members.json"
        E clico no botão "Confirmar Importação"
        Então vejo a mensagem de sucesso "Participantes importados com sucesso para a turma CIC0105-TA"
        E a lista de discentes da turma exibe o aluno "Ana Clara Jordao Perna"

  # ==================== CENÁRIOS TRISTES ====================

    Cenário: Tentativa de importar arquivo com formato inválido
        Quando clico no botão "Selecionar Arquivo"
        E seleciono o arquivo "relatorio.pdf"
        E clico no botão "Confirmar Importação"
        Então vejo a mensagem de erro "Formato de arquivo inválido. Por favor, envie um arquivo .json"
        E o sistema não realiza nenhuma alteração na base de dados

    Cenário: Importar arquivo JSON com estrutura corrompida
        Dado que possuo um arquivo "corrompido.json" com chaves faltando
        Quando clico no botão "Selecionar Arquivo"
        E seleciono o arquivo "corrompido.json"
        E clico no botão "Confirmar Importação"
        Then vejo a mensagem de erro "Erro na estrutura do arquivo: campos obrigatórios ausentes"

    Cenário: Tentativa de importação sem selecionar nenhum arquivo
        Quando clico no botão "Confirmar Importação" sem selecionar um arquivo
        Então vejo o alerta "Por favor, selecione um arquivo para importar"
        E permaneço na página de importação
