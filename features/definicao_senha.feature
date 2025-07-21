#language: pt
Funcionalidade: Sistema de definição de senha
  Eu como Usuário
  Quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro
  A fim de acessar o sistema

  Contexto:
    Dado que eu estou na página de registro do CAMAAR

  Cenário: Senha definida com sucesso (HAPPY)
    E que o email "myemail@email" não estiver registrado
    Quando eu preencher o campo "email" com "myemail@email"
    E eu preencher o campo "senha" com "mypassword"
    E eu clicar no botão "registrar"
    Então eu devo estar na página de login do CAMAAR
    E eu devo ver a mensagem "Usuário registrado com sucesso"
    E eu consigo logar com "myemail@email" e "mypassword"

  Cenário: Falha na definição de senha (SAD)
    E que o email "myemail@email" estiver registrado
    Quando eu preencher o campo "email" com "myemail@email"
    E eu preencher o campo "senha" com "mypassword"
    E eu clicar no botão "registrar"
    Então eu devo estar na página de registro do CAMAAR
    E eu devo ver a mensagem "Usuário com myemail@email já existe"