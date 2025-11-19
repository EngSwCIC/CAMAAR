# language: pt
# features/autenticacao.feature
Funcionalidade: Autenticação de Usuário
  Eu como Usuário do sistema
  Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
  A fim de responder formulários ou gerenciar o sistema

  Contexto:
    Dado que eu estou na página de login
    E existe um usuário "aluno" cadastrado com email "aluno@teste.com", matrícula "123456" e senha "senha123"
    E existe um usuário "admin" cadastrado com email "admin@teste.com", matrícula "987654", senha "admin123" e com permissão de administrador

  @happy_path
  Cenário: Login com email válido (Usuário Padrão)
    Quando eu preencho o campo "Login" com "aluno@teste.com"
    E eu preencho o campo "Senha" com "senha123"
    E eu clico no botão "Entrar"
    Então eu devo ser redirecionado para a página inicial
    E eu devo ver a mensagem "Login realizado com sucesso"
    E eu NÃO devo ver a opção "Gerenciamento" no menu lateral

  @happy_path
  Cenário: Login com email válido (Usuário Admin)
    Quando eu preencho o campo "Login" com "admin@teste.com"
    E eu preencho o campo "Senha" com "admin123"
    E eu clico no botão "Entrar"
    Então eu devo ser redirecionado para a página inicial
    E eu devo ver a mensagem "Login realizado com sucesso"
    E eu devo ver a opção "Gerenciamento" no menu lateral

  @happy_path
  Cenário: Login com matrícula válida
    Quando eu preencho o campo "Login" com "123456"
    E eu preencho o campo "Senha" com "senha123"
    E eu clico no botão "Entrar"
    Então eu devo ser redirecionado para a página inicial
    E eu devo ver a mensagem "Login realizado com sucesso"

  @sad_path
  Cenário: Login com senha incorreta
    Quando eu preencho o campo "Login" com "aluno@teste.com"
    E eu preencho o campo "Senha" com "senhaErrada"
    E eu clico no botão "Entrar"
    Então eu devo permanecer na página de login
    E eu devo ver a mensagem "Login ou senha inválidos"

  @sad_path
  Cenário: Login com usuário inexistente
    Quando eu preencho o campo "Login" com "naoexisto@teste.com"
    E eu preencho o campo "Senha" com "qualquercoisa"
    E eu clico no botão "Entrar"
    Então eu devo permanecer na página de login
    E eu devo ver a mensagem "Login ou senha inválidos"

  @sad_path
  Cenário: Tentativa de login de usuário pré-cadastrado (pendente)
    Dado que existe um usuário "José Novo" (111222) pré-cadastrado via SIGAA, mas com status "pendente"
    E eu estou na página de login
    Quando eu preencho o campo "Login" com "111222"
    E eu preencho o campo "Senha" com "qualquercoisa"
    E eu clico no botão "Entrar"
    Então eu devo permanecer na página de login
    E eu devo ver a mensagem "Sua conta está pendente. Por favor, redefina sua senha para ativar."

  @happy_path
  Cenário: Usuário pendente solicita redefinição de senha para ativar a conta
    Dado que existe um usuário "José Novo" (111222) pré-cadastrado via SIGAA, mas com status "pendente"
    E eu estou na página de "Esqueci minha senha"
    Quando eu preencho "Email ou Matrícula" com "111222"
    E eu clico no botão "Solicitar redefinição"
    Então eu devo ver a mensagem "Um link de ativação foi enviado para o seu email."
    E o status do usuário "111222" deve continuar "pendente"