# language: pt

Funcionalidade: Importar dados do SIGAA
    Eu como Administrador
    Quero importar dados de turmas, matérias e participantes do SIGAA (caso não existam na base de dados atual)
    A fim de alimentar a base de dados do sistema.

    # Happy Paths

    Cenário: Sucesso na importação dos dados 
        Dado que eu estou logado no sistema com um usuário do tipo admin
        E que estou na página de fluxo de gerenciamento do sistema
        Quando eu clicar no botão "Importar dados do SIGAA"
        Então o sistema irá ler os arquivos .json contendo os dados do SIGAA
        E carregará essas informações no sistema, como turmas, matérias e participantes
        E também mostrará uma mensagem de sucesso ao usuário

    # Sad Paths

    Cenário: Falha na autenticação
        Dado que eu estou logado no sitema com um usuário do tipo aluno
        E que estou na página de fluxo de gerenciamento do sistema
        Quando eu clicar no botão "Importar dados do SIGAA"
        Então o sistema não irá importar os dados
        E também mostrará uma mensagem de falha ao usuário
    
    Cenário: Erro ao ler os arquivos
        Dado que eu estou logado no sitema com um usuário do tipo admin
        E que estou na página de fluxo de gerenciamento do sistema
        Quando eu clicar no botão "Importar dados do SIGAA"
        Mas os dados estão estão corrompidos ou há a ausência desses arquivos
        Então o sistema não irá importar os dados
        E também mostrará uma mensagem de falha ao usuário

    Cenário: Os dados já foram previamente carregados
        Dado que eu estou logado no sitema com um usuário do tipo admin
        E que estou na página de fluxo de gerenciamento do sistema
        Quando eu clicar no botão "Importar dados do SIGAA"
        Mas o sistema já carregou os dados previamente
        Então o sistema não irá importar os dados
        E também mostrará uma mensagem de falha ao usuário