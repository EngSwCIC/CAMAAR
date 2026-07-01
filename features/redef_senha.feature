# language: pt

Funcionalidade: ReRedefinir senha a partir do e-mail de solicitação de troca de senha
    Como usuario
    Quero redefinir uma senha para o meu usuário a partir do e-mail recebido após a solicitação da troca de senha
    A fim de recuperar o meu acesso ao sistema

    Contexto:
        Dado que recebi um e-mail de solicitação de troca de senha no endereço "user@gmail.com"
        E cliquei no link de redefinição de senha contido no e-mail

  # ==================== CENÁRIOS FELIZES ====================

    Cenário: Redefinição de senha com sucesso
        Quando preencho o campo "Nova Senha" com "senhaUser"
        E preencho o campo "Confirmar Senha" com "senhaUser"
        E clico no botão "Redefinir Senha"
        Então sou redirecionado para o painel principal

  # ==================== CENÁRIOS TRISTES ====================

    Cenário: Senhas digitadas não coincidem
        Quando preencho o campo "Nova Senha" com "senhaUser"
        E preencho o campo "Confirmar Senha" com "senhaUserErrada"
        E clico no botão "Redefinir Senha"
        Então permaneço na página de redefinição de senha
        E vejo a mensagem de erro "As senhas não coincidem"

    Cenário: Senha não atende aos requisitos mínimos
        Quando preencho o campo "Nova Senha" com "senha"
        E preencho o campo "Confirmar Senha" com "senha"
        E clico no botão "Redefinir Senha"
        Então permaneço na página de redefinição de senha
        E vejo a mensagem de erro "A senha deve ter no mínimo 8 caracteres"

    Cenário: Campos de senha deixados em branco
        Quando deixo o campo "Nova Senha" em branco
        E deixo o campo "Confirmar Senha" em branco
        E clico no botão "Redefinir Senha"
        Então permaneço na página de redefinição de senha
        E vejo a mensagem de erro "Preencha todos os campos obrigatórios"

    Cenário: Link de redefinição de senha expirado
        Dado que o link de redefinição de senha foi enviado há mais de 24 horas
        Quando preencho o campo "Nova Senha" com "senhaUser"
        E preencho o campo "Confirmar Senha" com "senhaUser"
        E clico no botão "Redefinir Senha"
        Então vejo a mensagem de erro "Este link expirou. Solicite um novo link."
