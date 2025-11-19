# language: pt
# features/definir_senha_usuario.feature

Funcionalidade: Sistema de definição de senha
  Eu como Usuário
  Quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro
  A fim de acessar o sistema

  Contexto:
    Dado que o usuário "fulano.novo@email.com" foi importado e está com o status "pendente"
    E um link de definição de senha válido foi enviado para "fulano.novo@email.com"

  @happy_path
  Cenário: Definição de senha com sucesso
    Quando eu acesso a página "Defina sua Senha" usando o link válido
    E eu preencho o campo "Nova Senha" com "senhaForte123"
    E eu preencho o campo "Confirme a senha" com "senhaForte123"
    E eu clico no botão "Alterar Senha"
    Então eu devo ser redirecionado para a página de "Login"
    E eu devo ver a mensagem "Senha definida com sucesso! Você já pode fazer o login."
    E o status do usuário "fulano.novo@email.com" no sistema deve ser "ativo"

  @sad_path
  Cenário: Senhas não conferem
    Quando eu acesso a página "Defina sua Senha" usando o link válido
    E eu preencho o campo "Nova Senha" com "senhaForte123"
    E eu preencho o campo "Confirme a senha" com "outraCoisaDiferente"
    E eu clico no botão "Alterar Senha"
    Então eu devo permanecer na página "Defina sua Senha"
    E eu devo ver a mensagem de erro "As senhas não conferem."

  @sad_path
  Cenário: Tentar usar o link de definição de senha quando já está ativo
    Dado que o usuário "fulano.ativo@gmail.com" já está ativo no sistema
    Quando eu acesso a página "Defina sua Senha" usando o link antigo
    Então eu devo ser redirecionado para a página de "Login"
    E eu devo ver a mensagem "Você já está ativo. Faça o login."

  @sad_path
  Cenário: Campos em branco
    Quando eu acesso a página "Defina sua Senha" usando o link válido
    E eu deixo o campo "Nova Senha" em branco
    E eu deixo o campo "Confirme a senha" em branco
    E eu clico no botão "Alterar Senha"
    Então eu devo permanecer na página "Defina sua Senha"
    E eu devo ver a mensagem de erro "Todos os campos devem ser preenchidos."

  @sad_path
  Cenário: Campo "Senha" em branco
    Quando eu acesso a página "Defina sua Senha" usando o link válido
    E eu deixo o campo "Nova Senha" em branco
    E eu preencho o campo "Confirme a senha" com "senhaForte123"
    E eu clico no botão "Alterar Senha"
    Então eu devo permanecer na página "Defina sua Senha"
    E eu devo ver a mensagem de erro "Todos os campos devem ser preenchidos."

  @sad_path
  Cenário: Campo "Confirme a senha" em branco
    Quando eu acesso a página "Defina sua Senha" usando o link válido
    E eu preencho o campo "Nova Senha" com "senhaForte123"
    E eu deixo o campo "Confirme a senha" em branco
    E eu clico no botão "Alterar Senha"
    Então eu devo permanecer na página "Defina sua Senha"
    E eu devo ver a mensagem de erro "O campo 'Todos os campos devem ser preenchidos."