Funcionalidade: Autenticação de usuário no sistema
	Como um Usuário do sistema
	Eu quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
	A fim de responder formulários ou gerenciar o sistema

Cenário: Administrador faz login com sucesso (Caminho Feliz)
    Dado que eu estou na página de "Login"
    E existe um usuário "usuario_valido@alias" com a senha "senha123" e perfil "Admin"
    Quando eu preencho "E-mail ou Matrícula" com "usuario_valido@alias" ou "Matricula"
    E preencho "Senha" com "senha123"
    E clico em "Entrar"
    Então eu devo ser redirecionado para a página "Dashboard Admin"
    E eu devo ver o link "Gerenciamento" no menu lateral

Cenário: Aluno (usuário comum) faz login com sucesso (Caminho Feliz)
    Dado que eu estou na página de "Login"
    E existe um usuário "usuario_valido@alias" com a senha "senha456" e perfil "Aluno"
    Quando eu preencho "E-mail ou Matrícula" com "usuario_valido@alias" ou "Matricula"
    E preencho "Senha" com "senha456"
    E clico em "Entrar"
    Então eu devo ser redirecionado para a página "Dashboard Aluno"
    E eu não devo ver o link "Gerenciamento" no menu lateral

Cenário: Professor (usuário comum) faz login com sucesso (Caminho Feliz)
    Dado que eu estou na página de "Login"
    E existe um usuário "usuario_valido@alias" com a senha "senha456" e perfil "Aluno"
    Quando eu preencho "E-mail ou Matrícula" com "usuario_valido@alias" ou "Matricula"
    E preencho "Senha" com "senha456"
    E clico em "Entrar"
    Então eu devo ser redirecionado para a página "Dashboard Professor"
    E eu não devo ver o link "Gerenciamento" no menu lateral

Cenário: Usuário tenta fazer login com senha incorreta (Caminho Triste)
    Dado que eu estou na página de "Login"
    E existe um usuário "usuario_valido@alias" com a senha "senha456"
    Quando eu preencho "E-mail ou Matrícula" com "usuario_valido@alias" ou "Matricula"
    E preencho "Senha" com "senhaErrada"
    E clico em "Entrar"
    Então eu devo continuar na página de "Login"
    E eu devo ver a mensagem de erro "E-mail ou senha inválidos."
