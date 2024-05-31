# language: pt

Funcionalidade: Edição e Deleção de Templates
    Eu como Administrador
    Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
    A fim de organizar os templates existentes

    # Happy Paths

    Cenário: Sucesso na edição de um template
        Dado que eu estou logado no sistema com um usuário do tipo admin
        E que estou na página de templates
        Quando eu clicar no botão de editar um template
        E esse template não foi utilizado para gerar nenhum formulário
        Então o sistema irá abrir uma janela sobreposta para edição desse template
        E, ao editar os campos desejados, o admin pode salvar esse template 
        E o sistema irá mostrar uma mensagem de sucesso na operação

    Cenário: Sucesso na deleção de um template
        Dado que eu estou logado no sistema com um usuário do tipo admin
        E que estou na página de templates
        Quando eu clicar no botão de apagar um template
        E esse template não foi utilizado para gerar nenhum formulário
        Então o sistema irá apagar esse template
        E o sistema irá mostrar uma mensagem de sucesso na operação

    # Sad Paths

    Cenário: Falha na autenticação
        Dado que eu estou logado no sitema com um usuário do tipo aluno
        E que estou na página de templates
        Quando eu clicar no botão de editar ou apagar um template
        Então o sistema não modificará o template
        E também mostrará uma mensagem de falha de autorização ao usuário
    
    Cenário: Falha na edição de um template
        Dado que eu estou logado no sistema com um usuário do tipo admin
        E que estou na página de templates
        Quando eu clicar no botão de editar um template
        Mas esse template já foi utilizado para gerar algum formulário
        Então o sistema não editará o template
        E também mostrará uma mensagem de falha ao usuário, pois algum formulário já usou esse template

    Cenário: Falha na deleção de um template
        Dado que eu estou logado no sistema com um usuário do tipo admin
        E que estou na página de templates
        Quando eu clicar no botão de apagar um template
        Mas esse template já foi utilizado para gerar algum formulário
        Então o sistema não apagará o template
        E também mostrará uma mensagem de falha ao usuário, pois algum formulário já usou esse template