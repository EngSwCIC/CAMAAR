# language: pt
@auth @issue-105
Funcionalidade: Sistema de Definicao de Senha
  Como usuario recem-cadastrado
  Quero definir minha primeira senha por um link recebido por email
  Para ativar meu acesso ao CAMAAR

  Contexto:
    Dado que existe um participante importado do SIGAA com email "acjpjvjp@gmail.com", matricula "190084006" e sem senha definida
    E que o sistema enviou um link valido de definicao de senha para "acjpjvjp@gmail.com"

  Cenario: Usuario define a primeira senha com link valido
    Quando o usuario acessa o link valido de definicao de senha
    E informa a nova senha "Senha@123"
    E confirma a nova senha "Senha@123"
    E envia o formulario de definicao de senha
    Entao o sistema deve salvar a senha do usuario
    E deve ativar o acesso do usuario ao CAMAAR
    E deve permitir login com email ou matricula e a nova senha

  Cenario: Usuario nao define senha com link invalido
    Quando o usuario acessa um link invalido de definicao de senha
    Entao o sistema nao deve permitir a definicao de senha
    E deve exibir a mensagem "Link de definicao de senha invalido ou expirado"

  Cenario: Usuario nao define senha quando a confirmacao e diferente
    Quando o usuario acessa o link valido de definicao de senha
    E informa a nova senha "Senha@123"
    E confirma a nova senha "OutraSenha@123"
    E envia o formulario de definicao de senha
    Entao o sistema nao deve salvar a senha do usuario
    E deve exibir a mensagem "Confirmacao de senha nao confere"
