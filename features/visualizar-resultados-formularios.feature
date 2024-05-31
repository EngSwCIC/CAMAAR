# language: pt

Funcionalidade: Visualizar resultados dos formulários
    Eu como Administrador
    Quero visualizar os formulários criados
    A fim de poder gerar um relatório a partir das respostas

    # Happy Paths

    Cenário: Sucesso na visualização dos resultados
        Dado que eu estou logado no sistema com um usuário do tipo admin
        E que estou na página de fluxo de gerenciamento do sistema
        Quando eu clicar no botão "Visualizar resultados"
        Então o sistema irá abrir uma janela sobreposta
        E essa janela conterá uma lista de todas as turmas as quais já foram enviados o formulário

    # Sad Paths

    Cenário: Falha na autenticação
        Dado que eu estou logado no sitema com um usuário do tipo aluno
        E que estou na página de fluxo de gerenciamento do sistema
        Quando eu clicar no botão "Visualizar resultados"
        Então o sistema não irá abrir a janela sobreposta
        E também mostrará uma mensagem de falha de autorização ao usuário