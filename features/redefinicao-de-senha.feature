# language: pt

Funcionalidade: Redefinição de senha
    Eu como Usuário
    Quero redefinir uma senha para o meu usuário a partir do e-mail recebido após a solicitação da troca de senha
    A fim de recuperar o meu acesso ao sistema

    # Happy Paths

    Cenário: Sucesso na redefinição de senha
        Dado que sou um usuário cadastro no sistema
        E que estou pre-logado
        Dado que eu informo uma senha válida e a reverifico
        Quando eu clicar no botão "definir senha"
        Então o sistema irá definir minha nova senha no banco de dados
        E me logará com a conta do usuário
        E me redirecionará para a página inicial do sistema
        

    # Sad Paths

    Cenário: Falha ao pre-logar
        Dado que eu não estou pre-logado no sistema com um usuário
        Quando eu for para a página de definição de senha
        Então o sistema irá me redirecionar para a página de login
    
    Cenário: Erro de regra de senha
        Dado que eu estou pre-logado no sistema com um usuário
        E que estou na página  de definição de senha
        Dado que eu informo uma senha inválida e a reverifico
        Quando eu clicar no botão "definir senha"
        Então o sistema não irá redefinir  minha senha
        E me redirecionará para a página de definição de senha
        E também mostrará uma mensagem de falha ao usuário

    Cenário: A senha  não foi definida
        Dado que eu estou pre-logado no sistema com um usuário
        E que estou na página  de definição de senha
        Dado que informo  uma senha válida e a reverifico
        Quando eu clicar no botão "definir senha"
        Mas o sistema não conseguiu  definir minha senha
        Então o sistema não irá redefinir  minha senha
        E me redirecionará para a página de definição de senha
        E também mostrará uma mensagem de falha ao usuário
