# language: pt

Funcionalidade: Definir senha no primeiro acesso

  Como Usuario
  Quero Definir senha pela primeira vez a partir de link recebido por email
  Para acessar o sistema

  Cenário: Definir senha e concluir cadastro com sucesso
    Dado que recebi email para cadastrar-se na plataforma Camaar
    E abrir o link para cadastro de primeiro acesso
    E preencher a senha corretamente duas vezes
    Quando clicar em "Alterar senha"
    Então devo ser redirecionado para a página inicial
    E uma mensagem de sucesso ser mostrada

  Cenário: Link para definir senha e concluir cadastro expirou
    Dado que recebi email para cadastrar-se na plataforma Camaar
    Quando o prazo para cadastro tiver expirado
    Então uma mensagem informando que o link expirou deve ser mostrada
