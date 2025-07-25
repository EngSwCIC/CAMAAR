Funcionalidade: Redefinição de senha
  Como usuário do sistema (administrador, coordenador ou discente)
  Quero  redefinir minha senha caso eu a esqueça
  Para conseguir acessar minha conta com uma nova senha válida
  
  @feliz
  Cenário: Redefinir senha com sucesso
    Dado que estou na tela de login
    E que cliquei em "Esqueci minha senha"
    E que informei meu e-mail corretamente
    Quando recebo o link de redefinição e acesso a página
    E insiro uma nova senha válida
    Então vejo a mensagem "Senha alterada com sucesso"
    E posso usara nova senha para fazer login

  @triste
  Cenário: Nova senha não atende aos critérios
    Dado que estou na página de redefinição de senha
    Quando insiro uma nova senha com menos de 6 caracteres
    Então recebo a mensagem "A senha deve conter ao menos 6 caracteres"
    E a senha não é alterada

  @triste
  Cenário: Link de redefinição expirado ou inválido
    Dado que recebi o link de redefinição de senha
    E que o link jå expirou ou foi usado
    Quando tento acessar a página de redefinição
    Então vejo a mensagem "Link inválido ou expirado. Solicite uma nova redefinição de senha"


 