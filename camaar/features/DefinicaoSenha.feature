# language: pt
Funcionalidade: Sistema de definição de senha

  Eu como usuário
  Quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro
  Para acessar realizar meu primeiro acesso ao sistema

  # FELIZ
  Cenário: Definir senha com sucesso
    Dado que recebi um e-mail de solicitação de cadastro com um link para definir a senha
    Quando acesso o link de definição de senha
    E insiro uma nova senha válida
    E confirmo a nova senha
    E submeto o formulário
    Então minha senha é definida com sucesso
    E recebo uma mensagem de confirmação de que minha senha foi definida
    E posso realizar meu primeiro acesso ao sistema


  # TRISTE
  Cenário: Senha e confirmação de senha não coincidem
    Dado que recebi um e-mail de solicitação de cadastro com um link para definir a senha
    Quando acesso o link de definição de senha
    E insiro uma nova senha
    E insiro uma confirmação de senha diferente
    E submeto o formulário
    Então recebo uma mensagem de erro informando que a senha e a confirmação de senha não coincidem
    E sou instruído a corrigir os campos

  # TRISTE
  Cenário: Senha não atende aos critérios de segurança
    Dado que recebi um e-mail de solicitação de cadastro com um link para definir a senha
    Quando acesso o link de definição de senha
    E insiro uma senha que não atende aos critérios de segurança (por exemplo, muito curta,sem caracter numérico...)
    E submeto o formulário
    Então recebo uma mensagem de erro informando que a senha não atende aos critérios de segurança
    E sou instruído a inserir uma senha que atenda aos critérios





