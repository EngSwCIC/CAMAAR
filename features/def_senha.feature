# language: pt

Funcionalidade: Definir senha a partir do e-mail de solicitação de cadastro
    Como um usuário
    Quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro
    A fim de acessar o sistema

    Contexto:
        Dado que recebi um e-mail de solicitação de cadastro no endereço "user@gmail.com"
        E cliquei no link de definição de senha contido no e-mail

  # ==================== CENÁRIOS FELIZES ====================

    Cenário: Definição de senha com sucesso
        Quando preencho o campo "Nova Senha" com "senhaUser"
        E preencho o campo "Confirmar Senha" com "senhaUser"
        E clico no botão "Definir Senha"
        Então sou redirecionado para a página de login
        E vejo a mensagem "Senha definida com sucesso. Faça seu login."

  # ==================== CENÁRIOS TRISTES ====================

    Cenário: Senhas digitadas não coincidem
        Quando preencho o campo "Nova Senha" com "senhaUser"
        E preencho o campo "Confirmar Senha" com "senhaUserErrada"
        E clico no botão "Definir Senha"
        Então permaneço na página de definição de senha
        E vejo a mensagem de erro "As senhas não coincidem"

    Cenário: Senha não atende aos requisitos mínimos
        Quando preencho o campo "Nova Senha" com "senha"
        E preencho o campo "Confirmar Senha" com "senha"
        E clico no botão "Definir Senha"
        Então permaneço na página de definição de senha
        E vejo a mensagem de erro "A senha deve ter no mínimo 8 caracteres"

    Cenário: Campos de senha deixados em branco
        Quando deixo o campo "Nova Senha" em branco
        E deixo o campo "Confirmar Senha" em branco
        E clico no botão "Definir Senha"
        Então permaneço na página de definição de senha
        E vejo a mensagem de erro "Preencha todos os campos obrigatórios"

    Cenário: Link de definição de senha expirado
        Dado que o link de definição de senha foi enviado há mais de 24 horas
        Quando preencho o campo "Nova Senha" com "senhaUser"
        E preencho o campo "Confirmar Senha" com "senhaUser"
        E clico no botão "Definir Senha"
        Então vejo a mensagem de erro "Este link expirou. Solicite um novo cadastro."
