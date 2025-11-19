# language: pt
#3 pontos

Funcionalidade: Sistema de Login #104
    Eu como Usuário do sistema
    Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
    A fim de responder formulários ou gerenciar o sistema

    Contexto:
        Dado que existe um usuario aluno/professor registrado com:
        | email                | matricula | senha      |
        | helloworld@gmail.com | 012345678 | worldhello |  
        E um usuario admin registrado com 
        | email                | senha      |
        | admin@gmail.com      | admin      | 
        E estou na pagina "login"

    @104.1
    Cenário: 104.1 - Aluno/professor fornece as informacoes corretas utilizando email
        Quando eu preencher "email_ou_matricula" com "helloworld@gmail.com"
        E preencher "senha" com "worldhello"
        E clicar em "entrar"
        Entao eu devo ser redirecionado para a pagina "avaliacoes"
        E nao devo conseguir visualizar a opcao "gerenciamento"

    @104.2
    Cenário: 104.2 - Admin fornece as informacoes corretas utilizando email
        Quando eu preencher "email_ou_matricula" com "admin@gmail.com"
        E preencher "senha" com "admin"
        E clicar em "entrar"
        Entao eu devo ser redirecionado para a pagina "avaliacoes"
        E devo conseguir visualizar a opcao "gerenciamento"

    @104.3
    Cenário: 104.3 - Usuario fornece o email incorreto
        Quando eu preencher "email_ou_matricula" com "hellowor@gmail.com"
        E preencher "senha" com "worldhello"
        E clicar em "entrar"
        Entao eu devo visualizar a mensagem "Falha na autenticação. Usuário ou senha inválidos."

    @104.4
    Cenário: 104.4 - Usuario fornece o email correto e a senha incorreta
        Quando eu preencher "email_ou_matricula" com "helloworld@gmail.com"
        E preencher "senha" com "hello"
        E clicar em "entrar"
        Entao eu devo visualizar a mensagem "Falha na autenticação. Usuário ou senha inválidos."

    @104.5
    Cenário: 104.5 - Usuario fornece a matricula incorreta
        Quando eu preencher "email_ou_matricula" com "876543210"
        E preencher "senha" com "worldhello"
        E clicar em "entrar"
        Entao eu devo visualizar a mensagem "Falha na autenticação. Usuário ou senha inválidos."

    @104.6
    Cenário: 104.6 - Usuario fornece a matricula correta e a senha incorreta
        Quando eu preencher "email_ou_matricula" com "012345678"
        E preencher "senha" com "hello"
        E clicar em "entrar"
        Entao eu devo visualizar a mensagem "Falha na autenticação. Usuário ou senha inválidos."
    
    @104.7
    Cenário: 104.7 - Usuario tenta entrar sem nenhum campo de login preenchido
        Dado que os campos de login nao estao preenchidos
        E eu clicar em "entrar"
        Entao eu devo visualizar a mensagem "Falha na autenticação. Usuário ou senha inválidos."





