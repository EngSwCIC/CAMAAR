Funcionalidade: Cadastrar usuários do sistema
  Como administrador
  Quero cadastrar novos usuários com seus respectivos dados e permissões
  Para que eles possam acessar o sistema e participar das avaliações conforme seus papéis

  @feliz
  Cenário: Cadastro manual de usuário com sucesso
  Dado que estou logado como administrador
  Quando clico em "Cadastrar novo usuário"
  E preencho nome, e-mail, tipo de usuário e departamento
  Então o usuário é salvo com sucesso
  E recebe um e-mail com link para definição de senha

  @feliz
  Cenário: Cadastro em lote por planilha
  Dado que estou na tela de "Importar usuários"
  E possuo uma planilha válida com os dados dos novos usuários
  Quando faço upload do arquivo .json
  Então todos os usuários são cadastrados automaticamente
  E cada um recebe um e-mail para definição de senha

  @triste
  Cenário: Cadastro com e-mail inválido
  Dado que estou tentando cadastrar um novo usuário
  Quando informo um e-mail em formato inválido (ex: "professor@")
  Então vejo a mensagem "Formato de e-mail inválido"
  E o usuário não é salvo até que o campo seja corrigido