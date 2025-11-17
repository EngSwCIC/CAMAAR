# language: pt

Funcionalidade: Sistema de Login
  Como Usuário do sistema
  Eu quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
  Para que eu possa responder formulários ou gerenciar o sistema

  Contexto:
    Dado que existe um usuário cadastrado com email "usuario@aluno.unb.br" e matrícula "123456"
    E o usuário possui a senha "MinhaSenha123!" cadastrada
    E estou na página de login

  # ========================================
  # CENÁRIOS FELIZES
  # ========================================

  Cenário: Fazer login com email e senha corretos
    Quando eu preencho o campo "Email ou Matrícula" com "usuario@aluno.unb.br"
    E eu preencho o campo "Senha" com "MinhaSenha123!"
    E eu clico no botão "Entrar"
    Então eu devo ser redirecionado para a página inicial
    E eu devo ver meu nome de usuário no menu
    E eu devo estar autenticado no sistema

  Cenário: Fazer login com matrícula e senha corretos
    Quando eu preencho o campo "Email ou Matrícula" com "123456"
    E eu preencho o campo "Senha" com "MinhaSenha123!"
    E eu clico no botão "Entrar"
    Então eu devo ser redirecionado para a página inicial
    E eu devo ver meu nome de usuário no menu
    E eu devo estar autenticado no sistema

  Cenário: Administrador visualiza opção de gerenciamento no menu
    Dado que existe um administrador com email "admin@unb.br" e senha "Admin123!"
    Quando eu preencho o campo "Email ou Matrícula" com "admin@unb.br"
    E eu preencho o campo "Senha" com "Admin123!"
    E eu clico no botão "Entrar"
    Então eu devo ser redirecionado para a página inicial
    E eu devo ver a opção "Gerenciamento" no menu lateral
    E eu devo poder acessar a página de gerenciamento

  Cenário: Usuário comum não visualiza opção de gerenciamento
    Dado que o usuário não é administrador
    Quando eu faço login com sucesso
    Então eu devo ser redirecionado para a página inicial
    E eu não devo ver a opção "Gerenciamento" no menu lateral
    E eu devo ver apenas as opções disponíveis para usuários comuns

  # ========================================
  # CENÁRIOS TRISTES
  # ========================================

  Cenário: Tentar fazer login com email inexistente
    Quando eu preencho o campo "Email ou Matrícula" com "email_inexistente@aluno.unb.br"
    E eu preencho o campo "Senha" com "MinhaSenha123!"
    E eu clico no botão "Entrar"
    Então eu devo ver a mensagem de erro "Email ou senha inválidos"
    E eu devo permanecer na página de login
    E eu não devo estar autenticado no sistema

  Cenário: Tentar fazer login com senha incorreta
    Quando eu preencho o campo "Email ou Matrícula" com "usuario@aluno.unb.br"
    E eu preencho o campo "Senha" com "SenhaIncorreta123!"
    E eu clico no botão "Entrar"
    Então eu devo ver a mensagem de erro "Email ou senha inválidos"
    E eu devo permanecer na página de login
    E eu não devo estar autenticado no sistema

  Cenário: Tentar fazer login com matrícula inexistente
    Quando eu preencho o campo "Email ou Matrícula" com "999999"
    E eu preencho o campo "Senha" com "MinhaSenha123!"
    E eu clico no botão "Entrar"
    Então eu devo ver a mensagem de erro "Email ou senha inválidos"
    E eu devo permanecer na página de login

  Cenário: Tentar fazer login com campos vazios
    Quando eu deixo o campo "Email ou Matrícula" vazio
    E eu deixo o campo "Senha" vazio
    E eu clico no botão "Entrar"
    Então eu devo ver a mensagem de erro "Preencha todos os campos"
    E eu devo permanecer na página de login

  Cenário: Tentar fazer login com usuário que ainda não definiu senha
    Dado que existe um usuário importado que ainda não definiu senha
    Quando eu preencho o campo "Email ou Matrícula" com o email deste usuário
    E eu preencho o campo "Senha" com qualquer senha
    E eu clico no botão "Entrar"
    Então eu devo ver a mensagem "Você ainda não definiu sua senha. Verifique seu email para o link de cadastro"
    E eu devo permanecer na página de login

