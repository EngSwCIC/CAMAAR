# language: pt

Funcionalidade: Visualização de Resultados dos Formulários
    Eu como Administrador
    Quero visualizar os formulários criados
    A fim de poder gerar um relatório a partir das respostas

    # Happy Path
    Cenário: Visualizar Resultados de Formulário Existente 
        Dado que estou na pagina do admin
        Quando eu clicar em um formulário
        Então o sistema deve exibir a tela de resultados do formulário
        E a tela deve apresentar os resultados das respostas
        E eu devo poder gerar um relatório a partir dos resultados
    # Sad Path
    Cenário: Erro ao Visualizar Resultados 
        Dado que estou na tela de listagem de formulários
        Quando eu clicar em um formulário inexistente
        Então o sistema deve exibir uma mensagem de erro informando que o formulário não existe
        E eu não devo ter acesso à tela de resultados do formulário
