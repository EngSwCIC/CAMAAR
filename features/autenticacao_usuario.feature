Feature: Autenticação de usuário no sistema
    Como Usuário do sistema
    Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
    A fim de responder formulários ou gerenciar o sistema

    Background:
        Given que existem usuários cadastrados no sistema
        And que alguns usuários possuem perfil de administrador
        And que outros usuários possuem perfil de participante

    Scenario: Login com e-mail válido e senha correta
        When o usuário acessa a página de login
        And informa um e-mail válido cadastrado no sistema
        And informa a senha correta correspondente
        Then o sistema deve autenticar o usuário
        And deve redirecioná-lo para a página inicial do sistema

    Scenario: Login com matrícula válida e senha correta
        When o usuário acessa a página de login
        And informa uma matrícula válida cadastrada no sistema
        And informa a senha correta correspondente
        Then o sistema deve autenticar o usuário
        And deve redirecioná-lo para a página inicial do sistema

    Scenario: Exibir opção de gerenciamento para administrador
        Given que o usuário autenticado possui perfil de administrador
        When o usuário acessa o sistema após o login
        Then o sistema deve exibir no menu lateral a opção de gerenciamento

    Scenario: Não exibir opção de gerenciamento para usuário comum
        Given que o usuário autenticado não é administrador
        When o usuário acessa o sistema após o login
        Then o sistema não deve exibir a opção de gerenciamento no menu lateral

    Scenario: Login com senha incorreta
        When o usuário acessa a página de login
        And informa um e-mail ou matrícula válida
        And informa uma senha incorreta
        Then o sistema deve negar o acesso
        And exibir uma mensagem informando que a senha está incorreta

    Scenario: Login com usuário inexistente
        When o usuário acessa a página de login
        And informa um e-mail ou matrícula que não está cadastrada
        Then o sistema deve negar o acesso
        And exibir uma mensagem informando que o usuário não foi encontrado

    Scenario: Tentativa de login com campos vazios
        When o usuário tenta realizar login sem preencher e-mail/matrícula ou senha
        Then o sistema deve impedir o login
        And exibir uma mensagem informando que os campos são obrigatórios

    Scenario: Erro inesperado ao tentar autenticar
        When o usuário tenta fazer login
        And ocorre um erro interno inesperado
        Then o sistema deve exibir uma mensagem genérica de erro
        And instruir o usuário a tentar novamente mais tarde

