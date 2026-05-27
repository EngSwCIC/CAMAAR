# language: pt
Funcionalidade: Login de Usuários
  Como Usuário do sistema
  Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
  A fim de responder formulários ou gerenciar o sistema

  Contexto:
    Dado que a base de dados possui um usuário comum com e-mail "aluno@unb.br", matrícula "232000000" e senha "SenhaSegura123"
    E possui um usuário administrador com matrícula "111222" e senha "Admin123"

  @happy
  Cenário: Login com sucesso utilizando e-mail como Usuário Comum
    Dado que estou na página de login
    Quando eu preencho o campo "E-mail ou Matrícula" com "aluno@unb.br"
    E preencho o campo "Senha" com "SenhaSegura123"
    E clico no botão "Entrar"
    Então devo ser autenticado com sucesso
    E não devo visualizar a opção de gerenciamento no menu lateral

  @happy
  Cenário: Login com sucesso utilizando matrícula como Administrador (Regra de Negócio)
    Dado que estou na página de login
    Quando eu preencho o campo "E-mail ou Matrícula" com "111222"
    E preencho o campo "Senha" com "Admin123"
    E clico no botão "Entrar"
    Então devo ser autenticado com sucesso
    E devo visualizar a opção de gerenciamento no menu lateral

  @sad
  Cenário: Tentativa de login com senha incorreta
    Dado que estou na página de login
    Quando eu preencho o campo "E-mail ou Matrícula" com "aluno@unb.br"
    E preencho o campo "Senha" com "SenhaErrada!"
    E clico no botão "Entrar"
    Então devo ver a mensagem de erro "E-mail/Matrícula ou senha inválidos"
    E permaneço na página de login

  @sad
  Cenário: Tentativa de login deixando campos vazios (Validação de campo)
    Dado que estou na página de login
    Quando eu deixo o campo "E-mail ou Matrícula" vazio
    E deixo o campo "Senha" vazio
    E clico no botão "Entrar"
    Então devo ver o aviso "Campos obrigatórios não preenchidos"

  @sad
  Cenário: Tentativa de login sem preencher a senha
    Dado que estou na página de login
    Quando eu preencho o campo "E-mail ou Matrícula" com "usuario@email.com"
    E deixo o campo "Senha" vazio
    E clico no botão "Entrar"
    Então devo ver o aviso "O campo Senha é obrigatório"
