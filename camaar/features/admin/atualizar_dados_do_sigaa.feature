# language: pt

Funcionalidade: Atualizar Banco de Dados com Dados do SIGAA
    Eu como Administrador
    Quero atualizar a base de dados já existente com os dados atuais do SIGAA
    A fim de corrigir a base de dados do sistema
    
    # Happy Path
    Cenário: Atualizar Banco de Dados com Dados Atuais do SIGAA 
        Dado que estou na tela de gerenciamento
        Quando eu clicar no botão "Importar dados"
        Então o sistema deve atualizar a base de dados com os dados atuais do SIGAA
        E exibir uma mensagem de sucesso informando que a atualização foi realizada
    # Sad Path
    Cenário: Erro ao Atualizar Banco de Dados 
        Dado que estou na tela de gerenciamento
        Quando eu clicar no botão "Importar dados"
        E o sistema não conseguir atualizar os dados
        Então o sistema deve exibir uma mensagem de erro informando que a atualização falhou
