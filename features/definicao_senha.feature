# language: pt

@Issue-12

Funcionalidade: Sistema de definição de senha
    Eu como Usuário
    Quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro
    A fim de acessar o sistema

    Cenário: [Feliz] Definir senha com link válido
        Dado que recebo um e-mail com um link de definição de senha válido
        Quando eu acesso o link e preencho o campo "Nova Senha" com uma senha válida
        E preencho o campo "Confirmar Senha" com a mesma senha informada no campo "Nova Senha"
        E clico em "Salvar"
        Então a senha deve ser definida com sucesso
        E eu devo conseguir acessar o sistema utilizando a nova senha

    Cenário: [Triste] Tentar definir senha com link inválido
        Dado que recebo um e-mail com um link de definição de senha inválido ou expirado
        Quando eu tento acessar o link para definir minha senha
        Então devo ver uma mensagem "Link de definição de senha inválido ou expirado"
        E eu não devo conseguir definir minha senha

    Cenário: [Triste] Tentar definir senha com campos vazios
        Dado que recebo um e-mail com um link de definição de senha válido
        Quando eu acesso o link e não preencho os campos de senha
        E clico em "Salvar"
        Então devo ver a mensagem "Senha inválida"
        E eu não devo conseguir acessar o sistema
    
    Cenário: [Triste] Tentar definir senhas que não correspondem
        Dado que recebo um e-mail com um link de definição de senha válido
        Quando eu acesso o link e preencho com senhas que não correspondem
        E clico em "Salvar"
        Então devo ver a mensagem "Senha inválida"
        E eu não devo conseguir acessar o sistema

