# language: pt

Funcionalidade: Redefinição de senha
  Como usuário
  Para que eu possa recuperar o meu acesso ao sistema
  Eu quero redefinir uma senha para o meu usuário a partir do e-mail recebido após a solicitação da troca de senha

  Contexto:
    Dado que existe um usuário cadastrado com e-mail "usuario@unb.br" e senha "senhaantiga"

  @cenario_feliz
  Cenário: Solicitação de redefinição de senha bem-sucedida
    Dado que estou na página de login
    Quando clico em "Esqueci minha senha"
    E preencho "E-mail" com "usuario@unb.br"
    E clico em "Enviar e-mail de redefinição"
    Então devo ver a mensagem "Se este e-mail estiver cadastrado, você receberá as instruções em breve"

  @cenario_feliz
  Cenário: Redefinição de senha bem-sucedida com token válido
    Dado que o usuário "usuario@unb.br" solicitou redefinição de senha
    E que possuo um token de redefinição de senha válido
    Quando acesso a página de redefinição de senha
    E preencho "Nova senha" com "novasenha123"
    E preencho "Confirmar nova senha" com "novasenha123"
    E clico em "Redefinir senha"
    Então devo ser redirecionado para a página de login
    E devo ver a mensagem "Senha redefinida com sucesso. Faça login com sua nova senha"

  @cenario_feliz
  Cenário: Usuário consegue fazer login com nova senha após redefinição
    Dado que o usuário "usuario@unb.br" redefiniu a senha para "novasenha123"
    Quando acesso a página de login
    E preencho "E-mail ou Matrícula" com "usuario@unb.br"
    E preencho "Senha" com "novasenha123"
    E clico em "Entrar"
    Então devo ser redirecionado para a minha página inicial

  @cenario_triste
  Cenário: Senha antiga não funciona após redefinição
    Dado que o usuário "usuario@unb.br" redefiniu a senha para "novasenha123"
    Quando acesso a página de login
    E preencho "E-mail ou Matrícula" com "usuario@unb.br"
    E preencho "Senha" com "senhaantiga"
    E clico em "Entrar"
    Então devo permanecer na página de login
    E devo ver a mensagem "E-mail ou senha inválidos"

  @cenario_triste
  Cenário: Solicitação com e-mail não cadastrado
    Dado que estou na página de esqueci minha senha
    Quando preencho "E-mail" com "naoexiste@unb.br"
    E clico em "Enviar e-mail de redefinição"
    Então devo ver a mensagem "Se este e-mail estiver cadastrado, você receberá as instruções em breve"

  @cenario_triste
  Cenário: Solicitação com campo de e-mail vazio
    Dado que estou na página de esqueci minha senha
    Quando preencho "E-mail" com ""
    E clico em "Enviar e-mail de redefinição"
    Então devo permanecer na página de esqueci minha senha
    E devo ver a mensagem "Preencha o campo de e-mail"

  @cenario_triste
  Cenário: Solicitação com e-mail em formato inválido
    Dado que estou na página de esqueci minha senha
    Quando preencho "E-mail" com "emailsemarroba"
    E clico em "Enviar e-mail de redefinição"
    Então devo permanecer na página de esqueci minha senha
    E devo ver a mensagem "E-mail inválido"

  @cenario_triste
  Esquema do Cenário: Validações de nova senha com token válido
    Dado que o usuário "usuario@unb.br" solicitou redefinição de senha
    E que possuo um token de redefinição de senha válido
    Quando acesso a página de redefinição de senha
    E preencho "Nova senha" com "<nova_senha>"
    E preencho "Confirmar nova senha" com "<confirmacao>"
    E clico em "Redefinir senha"
    Então devo permanecer na página de redefinição de senha
    E devo ver a mensagem "<mensagem>"

    Exemplos:
      | nova_senha        | confirmacao       | mensagem                                     |
      | novasenha123      | outrasenha456     | As senhas não coincidem                      |
      | 123               | 123               | Senha deve ter no mínimo 6 caracteres        |
      | somenteminusculas | somenteminusculas | A senha deve conter pelo menos um número     |
      | NovaSenha123      | NovaSenha123      | A senha deve conter apenas letras minúsculas |

  @cenario_triste
  Esquema do Cenário: Campos obrigatórios na redefinição de senha
    Dado que o usuário "usuario@unb.br" solicitou redefinição de senha
    E que possuo um token de redefinição de senha válido
    Quando acesso a página de redefinição de senha
    E preencho "Nova senha" com "<nova_senha>"
    E preencho "Confirmar nova senha" com "<confirmacao>"
    E clico em "Redefinir senha"
    Então devo permanecer na página de redefinição de senha
    E devo ver a mensagem "Preencha todos os campos obrigatórios"

    Exemplos:
      | nova_senha   | confirmacao  |
      | ""           | novasenha123 |
      | novasenha123 | ""           |
      | ""           | ""           |

  @cenario_triste
  Cenário: Redefinição com token expirado
    Dado que o usuário "usuario@unb.br" solicitou redefinição de senha
    E que possuo um token de redefinição de senha expirado
    Quando acesso a página de redefinição de senha
    Então devo ver a mensagem "Link expirado. Solicite uma nova redefinição de senha"

  @cenario_triste
  Cenário: Redefinição com token inválido
    Dado que possuo um token de redefinição de senha inválido
    Quando acesso a página de redefinição de senha
    Então devo ver a mensagem "Link inválido"
    E não devo ver o formulário de redefinição de senha

  @cenario_triste
  Cenário: Redefinição com token já utilizado
    Dado que o token de redefinição de senha já foi utilizado anteriormente
    Quando acesso a página de redefinição de senha
    Então devo ver a mensagem "Este link já foi utilizado. Solicite uma nova redefinição de senha"
    E não devo ver o formulário de redefinição de senha

  @cenario_triste
  Cenário: Nova senha igual à senha antiga
    Dado que o usuário "usuario@unb.br" solicitou redefinição de senha
    E que possuo um token de redefinição de senha válido
    Quando acesso a página de redefinição de senha
    E preencho "Nova senha" com "senhaantiga"
    E preencho "Confirmar nova senha" com "senhaantiga"
    E clico em "Redefinir senha"
    Então devo permanecer na página de redefinição de senha
    E devo ver a mensagem "A nova senha não pode ser igual à senha anterior"