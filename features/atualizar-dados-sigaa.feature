# language: pt

Funcionalidade: Atualizar dados do SIGAA
    Eu como Administrador
    Quero atualizar a base de dados já existente com os dados atuais do sigaa
    A fim de corrigir a base de dados do sistema.

    # Happy Paths

    Cenário: Sucesso na atualizações dos dados 
        Dado que eu estou logado no sistema com um usuário do tipo admin
        E que estou na página de fluxo de gerenciamento do sistema
        Quando eu clicar no botão "Atualizar dados do SIGAA"
        E eu já tiver importado os dados previamente
        Então o sistema irá ler os arquivos .json contendo os dados do SIGAA
        E carregará essas informações no sistema, como turmas, matérias e participantes, atualizando os dados
        E também mostrará uma mensagem de sucesso ao usuário

    # Sad Paths

    Cenário: Falha na autenticação
        Dado que eu estou logado no sitema com um usuário do tipo aluno
        E que estou na página de fluxo de gerenciamento do sistema
        Quando eu clicar no botão "Atualizar dados do SIGAA"
        Então o sistema não irá atualizar os dados
        E também mostrará uma mensagem de falha ao usuário
    
    Cenário: Erro ao ler os arquivos
        Dado que eu estou logado no sitema com um usuário do tipo admin
        E que estou na página de fluxo de gerenciamento do sistema
        Quando eu clicar no botão "Atualizar dados do SIGAA"
        Mas os dados estão estão corrompidos ou há a ausência desses arquivos
        Então o sistema não irá atualizar os dados
        E também mostrará uma mensagem de falha ao usuário

    Cenário: Os dados nunca foram previamente carregados
        Dado que eu estou logado no sitema com um usuário do tipo admin
        E que estou na página de fluxo de gerenciamento do sistema
        Quando eu clicar no botão "Atualizar dados do SIGAA"
        Mas o sistema nunca carregou os dados previamente
        Então o sistema não irá atualizar os dados
        E também mostrará uma mensagem de falha ao usuário