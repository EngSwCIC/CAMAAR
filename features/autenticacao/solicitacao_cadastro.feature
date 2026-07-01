# language: pt
Funcionalidade: Solicitar primeiro acesso
  Como Usuário importado do SIGAA
  Quero solicitar o link de ativação da minha conta
  A fim de definir minha senha e acessar o sistema

  Contexto:
    Dado que existe um usuário importado pendente com matrícula "26100001" e e-mail "rafael@unb.br"

  @happy
  Cenário: Usuário pendente solicita link de primeiro acesso com sucesso
    Dado que o envio de e-mail de cadastro será bem-sucedido
    Quando solicito o primeiro acesso com matrícula "26100001" e e-mail "rafael@unb.br"
    Então deve existir um token de cadastro para a matrícula "26100001"
    E devo ver a mensagem de sucesso de envio de cadastro

  @sad
  Cenário: Usuário informa e-mail inválido na solicitação
    Quando solicito o primeiro acesso com matrícula "26100001" e e-mail "email_invalido"
    Então devo ver a mensagem de erro "Por favor, insira um formato de e-mail válido."
    E não deve existir token de cadastro para a matrícula "26100001"

  @sad
  Cenário: Usuário informa e-mail diferente do cadastro institucional
    Quando solicito o primeiro acesso com matrícula "26100001" e e-mail "outro_email@unb.br"
    Então devo ver a mensagem de erro "O e-mail informado não corresponde ao e-mail institucional desta matrícula."
    E não deve existir token de cadastro para a matrícula "26100001"

  @sad
  Cenário: Usuário ativo tenta solicitar primeiro acesso novamente
    Dado que a matrícula "26100001" já está ativa
    Quando solicito o primeiro acesso com matrícula "26100001" e e-mail "rafael@unb.br"
    Então devo ver a mensagem de erro "Esta matrícula já possui um cadastro ativo. Caso tenha esquecido sua senha, utilize a redefinição."
    E não deve existir token de cadastro para a matrícula "26100001"

  @sad
  Cenário: Serviço de e-mail falha ao enviar link de primeiro acesso
    Dado que o envio de e-mail de cadastro falhará
    Quando solicito o primeiro acesso com matrícula "26100001" e e-mail "rafael@unb.br"
    Então devo ver a mensagem de erro "Houve um erro técnico ao tentar enviar o e-mail. Tente novamente mais tarde."
