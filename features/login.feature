# language: pt

Funcionalidade: Login no sistema CAMAAR
    Como um usuário do sistema
    Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
    A fim de responder formulários ou gerenciar o sistema

    Contexto:
        Dado que os usuários estão cadastrados no sistema
        Dado que estou na página de login do CAMAAR

  # ==================== CENÁRIOS FELIZES ====================

    @javascript
    Cenário: Login bem-sucedido com e-mail válido
        Quando preencho o campo "Email ou Matrícula" com "user@gmail.com"
        E preencho o campo "Senha" com "senhaUser"
        E clico no botão "Entrar"
        Então sou redirecionado para o painel principal

    @javascript
    Cenário: Login bem-sucedido com matrícula válida
        Quando preencho o campo "Email ou Matrícula" com "190084006"
        E preencho o campo "Senha" com "senhaUser"
        E clico no botão "Entrar"
        Então sou redirecionado para o painel principal

    @javascript
    Cenário: Login como administrador exibe menu de gerenciamento
        Quando preencho o campo "Email ou Matrícula" com "admin@gmail.com"
        E preencho o campo "Senha" com "senhaAdmin"
        E clico no botão "Entrar"
        Então sou redirecionado para o painel principal
        E vejo a opção "Gerenciamento" no menu lateral

  # ==================== CENÁRIOS TRISTES ====================

    @javascript
    Cenário: Login com senha incorreta
        Quando preencho o campo "Email ou Matrícula" com "user@gmail.com"
        E preencho o campo "Senha" com "senhaErrada"
        E clico no botão "Entrar"
        Então permaneço na página de login
        E vejo a mensagem de erro "Credenciais inválidas"

    @javascript
    Cenário: Login com usuário não cadastrado
        Quando preencho o campo "Email ou Matrícula" com "nao.cadastrado@gmail.com"
        E preencho o campo "Senha" com "qualquerSenha"
        E clico no botão "Entrar"
        Então permaneço na página de login
        E vejo a mensagem de erro "Credenciais inválidas"

    @javascript
    Cenário: Login como usuário comum não exibe menu de gerenciamento
        Quando preencho o campo "Email ou Matrícula" com "user@gmail.com"
        E preencho o campo "Senha" com "senhaUser"
        E clico no botão "Entrar"
        Então sou redirecionado para o painel principal
        E não vejo a opção "Gerenciamento" no menu lateral