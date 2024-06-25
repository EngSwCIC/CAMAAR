# language: pt

Funcionalidade: Redefinição de Senha
    Eu como Usuário
    Quero redefinir uma senha para o meu usuário a partir do e-mail recebido após a solicitação da troca de senha
    A fim de recuperar o meu acesso ao sistema

    # Happy Path
    Cenário: O email de usuário está correto
        Dado que eu estou no meu e-mail de usuário
        E eu recebo o e-mail de troca de senha corretamente
        Quando eu clico em trocar senha 
        Então devo ser redirecionado a uma página de troca de senha 
        E devo poder trocar a minha senha atual por uma nova

    # Sad Path
    Cenário: O email de usuário não está correto
        Dado que eu estou em um e-mail qualquer
        E não tenho acessoa ao email de troca de senha
        Quando eu tentar trocar minha senha atual
        Então deve ser exibida uma mensagem de que não é possivel trocar minha senha 