Funcionalidade: Sistema de definição de senha
  Como novo usuário do sistema (administrador, coordenador oudiscente)
  Quero definir uma senha no meu primeiro acesso
  Para garantir a segurança do meu login pessoal

  @feliz
  Cenário: Definir senha com sucesso no primeiro acesso
    Dado que recebi um e-mail de boas-vindas com um link para definir minha senha
    E que o link está dentro do prazo de validade
    Quando acesso o link e informo uma senha válida (mínimo 8 caracteres, pelo menos 1 número)
    Então vejo a mensagem "Senha criada com sucesso"
    E sou redirecionado à tela de login
    
  @triste
  Cenário: Definir senha com critérios inválidos
    Dado que estou na página de definição de senha
    Quando tento cadastrar uma senha sem número ou com menos de 6 caracteres
    Então recebo a mensagem "A senha deve conter ao menos 6 caracteres e 1 número"
    E a senha não é salva

  @triste
  Cenário: Link de definição de senha expirado
    Dado que recebi o link de definição de senha
    E que já se passaram mais de 48h desde o envio
    Quando tento acessar o link
    Então vejo a mensagem "Este link expirou. Solicite um novo convite de acesso"


  