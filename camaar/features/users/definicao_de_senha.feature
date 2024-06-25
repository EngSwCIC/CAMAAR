# language: pt

Funcionalidade: Sistema de Definição de senha
    Como Usuário do Sistema
    Quero definir uma senha a partir do e-mail do sistema de solicitação de cadastro
    Para que possa acessar o sistema

    # O cadastro do aluno/professor como usuário só é realmente efetivado após a definição da senha.

    # Happy path
    Cenario: Definir senha com sucesso
        Dado que o usuário informou o e-mail
        Quando o usuário solicitar a definição de senha
        Então o sistema deve enviar um e-mail com um link para definição de senha

    # Sad path
    Cenario: Definir senha com e-mail inválido
        Dado que o usuário informou um e-mail inválido
        Quando o usuário solicitar a definição de senha
        Então o sistema deve exibir uma mensagem de erro

    # Sad path
    Cenario: Definir senha com e-mail não cadastrado
        Dado que o usuário informou um e-mail não cadastrado
        Quando o usuário solicitar a definição de senha
        Então o sistema deve exibir uma mensagem de erro

    # Happy path
    Cenario: Definir senha com e-mail cadastrado
        Dado que o usuário informou um e-mail cadastrado
        Quando o usuário solicitar a definição de senha
        Então o sistema deve enviar um e-mail com um link para definição de senha
