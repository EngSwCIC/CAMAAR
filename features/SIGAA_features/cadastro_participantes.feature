# language: pt

Funcionalidade: Cadastro e Ativação de Participantes do SIGAA
  Como Administrador
  Para que eles acessem o sistema CAMAAR
  Eu quero cadastrar participantes de turmas do SIGAA ao importar dados de usuários novos para o sistema

  Contexto:
    Dado que o processo de importação gerou novos usuários no banco de dados

  @cenario_feliz
  Cenário: Definição de senha e efetivação do cadastro
    Dado que novos participantes foram importados do SIGAA com a flag ativo como falsa
    Quando o sistema envia um e-mail com o link de definição de senha para o endereço eletrônico cadastrado
    E o usuário clica no link e cadastra uma senha válida
    Então o sistema deve alterar o status do usuário para ativo
    E liberar o acesso ao sistema CAMAAR

  @cenario_triste
  Cenário: Tentativa de login de usuário inativo ou sem senha definida
    Dado que um usuário foi importado do SIGAA, mas ainda não definiu sua senha
    Quando ele tenta acessar o sistema inserindo seu e-mail e qualquer senha
    Então o sistema deve negar o acesso
    E exibir a mensagem "Cadastro pendente: Verifique seu e-mail para definir sua senha de acesso."

  @cenario_triste
  Cenário: Falha no envio da solicitação por e-mail inválido
    Quando o sistema tenta disparar os e-mails de solicitação de senha
    E o endereço eletrônico vindo do SIGAA está mal formatado ou não existe
    Então o sistema deve registrar a falha de envio no log
    E o usuário permanecerá com o status inativo até que a correção seja feita manualmente

  @cenario_triste
  Cenário: Link de definição de senha expirado
    Dado que um usuário recém-importado recebeu o e-mail de definição de senha
    Quando ele acessa o link após o período de validade
    Então o sistema deve exibir a mensagem "Link expirado."
    E apresentar um botão para "Solicitar novo link de ativação" sem alterar o status no banco de dados