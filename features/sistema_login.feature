# language: pt

@Issue-13

Funcionalidade: Sistema de Login
    Eu como Usuário do sistema
    Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
    A fim de responder formulários ou gerenciar o sistema

    Cenário: [Feliz] Credenciais de usuário com perfil "Discente" válido
        Dado que acesso o formulário de "Login"
        Quando eu preencho o campo de "E-mail ou matrícula" com um e-mail ou matrícula de um "Discente" cadastrado
        E preencho o campo "Senha" com a senha correspondente válida
        E clico no botão "Entrar"
        Então devo ser redirecionado para a página com perfil de "Discente"
        E não devo ver a opção de "Gerenciamento" no menu lateral

    Cenário: [Feliz] Credenciais de usuário com perfil "Administrador" válido
        Dado que acesso o formulário de "Login"
        Quando eu preencho o campo de "E-mail ou matrícula" com um e-mail ou matrícula de um "Administrador" cadastrado
        E preencho o campo "Senha" com a senha correspondente válida
        E clico no botão "Entrar"
        Então devo ser redirecionado para a página com perfil de "Administrador" 
        E devo ver a opção de "Gerenciamento" no menu lateral

    Cenário: [Triste] Usuário inexistente
        Dado que acesso o formulário de "Login"
        Quando eu preencho o campo de "E-mail ou matrícula" com um e-mail ou matrícula não cadastrado
        E preencho o campo "Senha" com qualquer senha
        E clico no botão "Entrar"
        Então devo ver uma mensagem "Usuário e/ou senha inválidos"

    Cenário: [Triste] Usuário cadastrado com senha incorreta
        Dado que acesso o formulário de "Login"
        Quando eu preencho o campo de "E-mail ou matrícula" com um e-mail ou matrícula cadastrado
        E preencho o campo "Senha" com uma senha não correspondente
        E clico no botão "Entrar"
        Então devo ver uma mensagem "Usuário e/ou senha inválidos"