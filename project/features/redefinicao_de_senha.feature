# language: pt
@auth @issue-107
Funcionalidade: Redefinicao de Senha
  Como usuario cadastrado
  Quero solicitar a redefinicao da minha senha por email
  Para recuperar meu acesso ao CAMAAR

  Contexto:
    Dado que existe um participante cadastrado com email "acjpjvjp@gmail.com", matricula "190084006" e senha definida "Senha@123"

  Cenario: Usuario redefine a senha com token valido
    Quando o usuario acessa a pagina de esqueci minha senha
    E informa o email "acjpjvjp@gmail.com"
    E solicita a redefinicao de senha
    Entao o sistema deve enviar um email com link de redefinicao para "acjpjvjp@gmail.com"
    Quando o usuario acessa o link valido de redefinicao de senha
    E informa a nova senha "NovaSenha@123"
    E confirma a nova senha "NovaSenha@123"
    E envia o formulario de redefinicao de senha
    Entao o sistema deve atualizar a senha do usuario
    E deve permitir login com a nova senha

  Cenario: Sistema nao revela se email inexistente esta cadastrado
    Quando o usuario acessa a pagina de esqueci minha senha
    E informa o email "naoexiste@unb.br"
    E solicita a redefinicao de senha
    Entao o sistema deve exibir uma mensagem generica de instrucao
    E nao deve revelar se o email esta cadastrado
    E nao deve criar token de redefinicao para usuario inexistente

  Cenario: Usuario nao redefine senha com token expirado
    Dado que existe um link expirado de redefinicao de senha para "acjpjvjp@gmail.com"
    Quando o usuario acessa o link expirado de redefinicao de senha
    E informa a nova senha "NovaSenha@123"
    E confirma a nova senha "NovaSenha@123"
    E envia o formulario de redefinicao de senha
    Entao o sistema nao deve atualizar a senha do usuario
    E deve exibir a mensagem "Link de redefinição de senha inválido ou expirado"
