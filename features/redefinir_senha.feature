Feature: Redefinição de senha via e-mail
    Como Usuário
    Quero redefinir minha senha a partir do e-mail recebido após a solicitação
    A fim de recuperar meu acesso ao sistema

    Background:
        Given que o usuário possui um cadastro válido no sistema

    Scenario: Solicitar redefinição de senha com sucesso
        When o usuário acessa a página de recuperação de senha
        And informa um e-mail válido associado à sua conta
        Then o sistema deve enviar um e-mail contendo um link para redefinição de senha
        And deve exibir uma mensagem informando que o e-mail foi enviado

    Scenario: Solicitar redefinição com e-mail não cadastrado
        When o usuário acessa a página de recuperação de senha
        And informa um e-mail que não está cadastrado no sistema
        Then o sistema deve exibir uma mensagem informando que o e-mail não foi encontrado
        And não deve enviar nenhum link de redefinição

    Scenario: Acessar link de redefinição válido
        Given que o usuário recebeu o e-mail de recuperação com um link válido
        When o usuário clica no link de redefinição dentro do prazo de validade
        Then o sistema deve exibir a página de criação de nova senha

    Scenario: Redefinir senha com sucesso
        Given que o usuário está na página de redefinição de senha
        When o usuário informa uma nova senha válida
        And confirma a nova senha corretamente
        Then o sistema deve atualizar a senha do usuário
        And deve exibir uma mensagem de sucesso
        And o usuário deve poder acessar o sistema com a nova senha

    Scenario: Link de redefinição expirado
        Given que o usuário recebeu o e-mail, mas o link já expirou
        When o usuário tenta acessar o link de redefinição
        Then o sistema deve informar que o link não é mais válido
        And deve instruir o usuário a solicitar um novo link

    Scenario: Erro ao redefinir devido a senhas não coincidentes
        Given que o usuário está na página de redefinição de senha
        When o usuário informa uma senha e uma confirmação que não coincidem
        Then o sistema deve impedir a atualização
        And exibir uma mensagem informando que as senhas devem ser iguais

    Scenario: Usuário tenta redefinir senha com critérios inválidos
        Given que o usuário está na página de redefinição de senha
        When o usuário informa uma senha que não atende aos requisitos mínimos
        Then o sistema deve impedir a redefinição
        And exibir uma mensagem explicando as regras de senha
