Feature: Definição de senha para o usuário a partir do e-mail do sistema de solicitação de cadastro
    Como Usuário
    Quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro
    A fim de acessar o sistema

    Background:
        Given que o usuário possui um cadastro pendente de ativação
        And que o sistema enviou um e-mail contendo um link para definição de senha

    Scenario: Acessar link de definição de senha com sucesso
        When o usuário clica no link recebido por e-mail
        Then o sistema deve exibir a página para criação da senha inicial
        And o link deve ser validado como autêntico e dentro do prazo de validade

    Scenario: Definir senha inicial com sucesso
        Given que o usuário está na página de criação de senha
        When o usuário informa uma senha válida
        And confirma a senha corretamente
        Then o sistema deve registrar a nova senha
        And ativar o cadastro do usuário
        And exibir uma mensagem informando que o acesso foi liberado

    Scenario: Senhas não coincidem
        Given que o usuário está na página de criação de senha
        When o usuário informa uma senha e uma confirmação que não coincidem
        Then o sistema deve impedir a criação da senha
        And exibir uma mensagem informando que as senhas devem ser iguais

    Scenario: Senha não atende aos critérios mínimos
        Given que o usuário está na página de criação de senha
        When o usuário informa uma senha que não atende às regras 
        Then o sistema deve impedir a criação da senha
        And exibir uma mensagem explicando os critérios obrigatórios

    Scenario: Usuário já definiu a senha anteriormente
        Given que o usuário já ativou sua conta e definiu uma senha previamente
        When tenta acessar novamente o link de definição de senha
        Then o sistema deve bloquear a ação
        And exibir uma mensagem informando que a conta já foi ativada