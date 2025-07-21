#language: pt
Funcionalidade: Sistema de Login
  Eu como Usuário do sistema
  Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
  A fim de responder formulários ou gerenciar o sistema
  Obs: Quando o Usuário logado for um admin, deve-se mostrar a opção de gerenciamente no menu lateral.

  Contexto:
    Dado que eu estou na página de login do CAMAAR

  Cenário: Login realizado com sucesso    (HAPPY)
    Quando eu preencher o campo “email” com “email@registrado”
    E eu preencher o campo “senha” com “senhaCorreta”
    E eu clicar no botão “login”
    Então eu devo ver a página inicial do CAMAAR

  Cenário: Login com e-mail não cadastrados    (SAD)
    Quando eu preencher o campo “email” com “email@nãoRegistrado”
    E eu preencher o campo “senha” com “senhaCorreta”
    E eu clicar no botão “login”
    Então eu devo ver “Usuário ou senha incorretos”

  Cenário: Login com senha incorreta      (SAD)
    Quando eu preencher o campo “email” com “email@registrado”
    E eu preencher o campo “senha” com “senhaIncorreta”
    E eu clicar no botão “login”
    Então eu devo ver “Usuário ou senha incorretos”