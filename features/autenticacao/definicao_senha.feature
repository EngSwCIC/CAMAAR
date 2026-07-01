# language: pt
Funcionalidade: Definição de Senha (Primeiro Acesso)
  Como Usuário importado do SIGAA
  Quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro
  A fim de acessar o sistema

  Contexto:
    Dado que fui importado do SIGAA mas ainda não possuo senha cadastrada

  @happy
  Cenário: Definição de senha com sucesso no primeiro acesso
    Dado que acessei o link de ativação contido no e-mail de cadastro enviado pelo sistema
    Quando eu preencho o campo "Nova Senha" com "NovaSenha123"
    E preencho o campo "Confirme a Senha" com "NovaSenha123"
    E clico em "Definir Senha"
    Então meu usuário deve ser ativado na base de dados
    E devo ver a mensagem "Cadastro ativado com sucesso!"

  @sad
  Cenário: Tentar definir senha com campos divergentes
    Dado que acessei o link de ativação contido no e-mail de cadastro enviado pelo sistema
    Quando eu preencho o campo "Nova Senha" com "NovaSenha123"
    E preencho o campo "Confirme a Senha" com "SenhaDiferente99"
    E clico em "Definir Senha"
    Então devo ver a mensagem de erro "A confirmação da senha não confere"
    E o meu usuário deve continuar inativo

  @sad
  Cenário: Tentar definir senha deixando os campos vazios (Validação de preenchimento)
    Dado que acessei o link de ativação contido no e-mail de cadastro enviado pelo sistema
    Quando eu deixo o campo "Nova Senha" vazio
    E deixo o campo "Confirme a Senha" vazio
    E clico em "Definir Senha"
    Então devo ver a mensagem de erro "Os campos de senha são obrigatórios"
    E o meu usuário deve continuar inativo
