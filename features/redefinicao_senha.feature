# language: pt

@Issue-10

Funcionalidade: Redefinição de senha
    Eu como Usuário
    Quero redefinir uma senha para o meu usuário a partir do e-mail recebido após a solicitação da troca de senha
    A fim de recuperar o meu acesso ao sistema
    
    Cenário: [Feliz] Solicitar redefinição de senha
        Dado que eu estou na página de Login
        Quando eu clico em "Redefinir senha"
        E preencho o campo "E-mail" com um e-mail cadastrado
        E clico em "Confirmar"
        Então o link de redefinição deve ser gerado e enviado para o e-mail cadastrado
    
    Cenário: [Feliz] Redefinir senha com link válido
        Dado que recebo um e-mail com um link de redefinição de senha válido
        Quando eu acesso o link e preencho o campo "Nova Senha" com uma senha válida
        E preencho o campo "Confirmar Senha" com a mesma senha informada no campo "Nova Senha"
        E clico em "Salvar"
        Então a senha deve ser redefinida com sucesso
        E eu devo conseguir acessar o sistema utilizando a nova senha
        E não devo conseguir acessar o sistema com a senha anterior

    Cenário: [Triste] Tentar redefinir senha com campos vazios
        Dado que recebo um e-mail com um link de redefinição de senha válido
        Quando eu acesso o link e não preencho os campos de senha
        E clico em "Salvar"
        Então devo ver a mensagem "Senha inválida"
        E eu não devo conseguir acessar o sistema
    
    Cenário: [Triste] Tentar redefinir senhas que não correspondem
        Dado que recebo um e-mail com um link de redefinição de senha válido
        Quando eu acesso o link e preencho com senhas que não correspondem
        E clico em "Salvar"
        Então devo ver a mensagem "Senha inválida"
        E eu não devo conseguir acessar o sistema
    
    Cenário: [Triste] Tentar redefinir senha com link inválido
        Dado que recebo um e-mail com um link de redefinição de senha inválido ou expirado
        Quando eu tento acessar o link para redefinir minha senha
        Então devo ver uma mensagem "Link de redefinição de senha inválido ou expirado"
        E não devo conseguir redefinir minha senha



