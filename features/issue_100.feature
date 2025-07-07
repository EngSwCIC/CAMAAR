# language: pt

Funcionalidade: Enviar email para cadastro no sistema

  Como administrador
  Quero cadastrar usuários no sistema após importar JSON com dados de novos usuários
  Para que novos usuários tenham acesso ao CAMARA

  Cenário: Enviar email pedindo cadastro após importar JSON
    Dado que importei com sucesso um JSON com novos usuário
    Quando clicar em "Enviar email de primeiro acesso"
    Então um email deve ser enviado para todos os novos usuários importados via JSON com um link pedindo cadastrar senha de primeiro acesso

  Cenário: Certos emails solicitando cadastro não puderam ser enviados
    Dado que importei com sucesso um JSON com novos usuário
    Quando clicar em "Enviar email de primeiro acesso"
    E alguns emails não puderam ser enviados
    Então uma mensagem de alerta deve ser exibida mostrando todos os emails que não puderam ser entregues
