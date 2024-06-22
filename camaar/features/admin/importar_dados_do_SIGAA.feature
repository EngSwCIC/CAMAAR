# language: pt

Funcionalidade: Importar Dados do SIGAA
    Eu como Administrador
    Quero importar dados de turmas, matérias e participantes do SIGAA (caso não existam na base de dados atual)
    Para que possa alimentar a base de dados do sistema

    # Happy Path
    Cenário: Importar Dados do SIGAA
        Dado que estou na tela de configurção # Não tenho certeza de qual tela será aqui
        Quando eu clicar no botão "Importar Dados do SIGAA"
        Então o sistema deve importar os dados de turmas, matérias e participantes do SIGAA
        E exibir uma mensagem de sucesso

    # Sad Path
    Cenário: Erro ao Importar Dados
        Dado que estou na tela de configurção # ?
        Quando eu clicar no botão "Importar Dados do SIGAA"
        E o sistema não conseguir importar os dados
        Então o sistema deve exibir uma mensagem de erro

    Cenário: Dados já Importados
        Dado que estou na tela de configurção # ?
        Quando eu clicar no botão "Importar Dados do SIGAA"
        E os dados já estiverem atualizados
        Então o sistema deve exibir uma mensagem informando que os dados são os mais recentes
