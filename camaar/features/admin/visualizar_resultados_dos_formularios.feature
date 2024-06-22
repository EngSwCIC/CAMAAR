# language: pt

Funcionalidade: Visualização de Resultados dos Formulários
    Eu como Administrador
    Quero visualizar os formulários criados
    A fim de poder gerar um relatório a partir das respostas

    # Happy Path
    Cenário: Visualizar Resultados de Formulário Existente 
        Dado que estou na pagina de gerenciamento
        Quando eu clicar em "Resultados"
        Então o sistema deve exibir a tela de resultados dos formulários
        E a tela deve apresentar os resultados das respostas
        E eu devo poder gerar um relatório a partir dos resultados
    # Sad Path
    Cenário: Erro ao Visualizar Resultados 
        Dado que estou na pagina de gerenciamento
        Quando eu clicar em "Resultados"
        Então o sistema deve exibir a tela de resultados dos formulários
        Quando clicar no cartão
        E nao gerar um relatorio
        Então deve aparecer uma mensagem de erro
