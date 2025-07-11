Funcionalidade: Sistema de Login
  Como usuário cadastrado (administrador, coordenador ou discente)
  Quero acessar o sistema com minhas credenciais (e-mail e senha)
  Para utilizar as funcionalidades disponíveis conforme meu perfil

  @feliz
  Cenário: Login com sucesso
  Dado que sou um usuário cadastrado no sistema
  E que estou na tela de login
  Quando informo meu e-mail e senha corretamente
  Então sou redirecionado para о painel inicial do meu perfil
  E tenho acesso às funcionalidades do meu tipo de usuário

  @feliz
  Cenário: Login com diferentes perfis
  Dado que sou um usuário do tipo "Administrador"
  Quando faço login com minhas credenciais
  Então vejo o painel administrativo com acesso a todos os departamentos
  Mas se o login for de um "Coordenador"
  Então o painel exibido é restrito ao seu departamento

  @triste
  Cenário: Tentativa de login com e-mail não cadastrado
  Dado que estou na tela de login
  E que informei um e-mail que não existe no sistema
  Quando tento prosseguir com o login
  Então receboamensagem "Email ou senha inválidos"
  E posso tentar novamente

  @triste
  Cenário: Login com senha incorreta
  Dado que estou na tela de login
  E que informei um e-mail existente
  Quando digito uma senha incorreta
  Então vejo a mensagem "E-mail ou senha inválidos"
  E permaneço na tela de login