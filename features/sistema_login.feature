Feature: Autenticação de Usuário
  Como Usuário do sistema
  Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
  A fim de responder formulários ou gerenciar o sistema

  Scenario: Login com credenciais válidas usando e-mail (feliz)
    Given que existe um usuário cadastrado com email "usuario@exemplo.com" e senha "123456"
    And estou na página de login
    When eu informo o email "usuario@exemplo.com" e a senha "123456"
    Then o sistema deve autenticar o usuário
    And deve exibir a página inicial do sistema

  Scenario: Login com credenciais válidas usando matrícula (feliz)
    Given que existe um usuário cadastrado com matrícula "202312345" e senha "abc123"
    And estou na página de login
    When eu informo a matrícula "202312345" e a senha "abc123"
    Then o sistema deve autenticar o usuário
    And deve exibir a página inicial do sistema

  Scenario: Login com credenciais inválidas (triste)
    Given que estou na página de login
    When eu informo o identificador "usuario@exemplo.com" e a senha "senha_incorreta"
    Then o sistema deve exibir uma mensagem de erro de autenticação
    And não deve permitir o acesso ao sistema

  Scenario: Login de administrador exibe opções de gerenciamento (feliz)
    Given que existe um usuário administrador com email "admin@exemplo.com" e senha "admin123"
    And estou na página de login
    When eu informo o email "admin@exemplo.com" e a senha "admin123"
    Then o sistema deve autenticar o usuário
    And deve exibir a página inicial do sistema
    And deve mostrar a opção "Gerenciamento" no menu lateral

  Scenario: Login de usuário comum não exibe opções de gerenciamento (feliz)
    Given que existe um usuário comum com email "user@exemplo.com" e senha "user123"
    And estou na página de login
    When eu informo o email "user@exemplo.com" e a senha "user123"
    Then o sistema deve autenticar o usuário
    And deve exibir a página inicial do sistema
    And não deve mostrar a opção "Gerenciamento" no menu lateral

  Scenario: Tentativa de login sem preencher todos os campos (triste)
    Given que estou na página de login
    When eu tento entrar no sistema sem preencher o identificador ou a senha
    Then o sistema deve informar que todos os campos são obrigatórios
    And não deve prosseguir com a autenticação
