# language: pt

Funcionalidade: Redefinição de senha
  Como Usuário do sistema
  Eu quero redefinir uma senha para o meu usuário a partir do e-mail recebido após a solicitação da troca de senha
  Para que eu possa recuperar o meu acesso ao sistema

  Contexto:
    Dado que existe um usuário cadastrado com email "usuario@aluno.unb.br"
    E o usuário possui uma senha cadastrada no sistema

  # ========================================
  # CENÁRIOS FELIZES
  # ========================================

  Cenário: Solicitar redefinição de senha com email válido
    Dado que estou na página de login
    Quando eu clico no link "Esqueci minha senha"
    E eu preencho o campo de email com "usuario@aluno.unb.br"
    E eu clico no botão "Enviar solicitação"
    Então eu devo ver a mensagem "Instruções para redefinir sua senha foram enviadas para seu e-mail"
    E o usuário deve receber um email com link de redefinição de senha
    E o link deve expirar em 24 horas

  Cenário: Redefinir senha com token válido
    Dado que solicitei a redefinição de senha
    E recebi o email com o link de redefinição
    Quando eu clico no link de redefinição no email
    E eu preencho o campo "Nova senha" com "NovaSenha123!"
    E eu preencho o campo "Confirmar senha" com "NovaSenha123!"
    E eu clico no botão "Redefinir senha"
    Então eu devo ver a mensagem "Senha redefinida com sucesso"
    E eu devo ser redirecionado para a página de login
    E a nova senha deve estar ativa no sistema

  Cenário: Redefinir senha usando matrícula
    Dado que estou na página de login
    Quando eu clico no link "Esqueci minha senha"
    E eu preencho o campo de identificação com "123456"
    E eu clico no botão "Enviar solicitação"
    Então eu devo ver a mensagem "Instruções para redefinir sua senha foram enviadas para seu e-mail"
    E o email associado à matrícula deve receber o link de redefinição

  # ========================================
  # CENÁRIOS TRISTES
  # ========================================

  Cenário: Tentar solicitar redefinição com email inexistente
    Dado que estou na página de login
    Quando eu clico no link "Esqueci minha senha"
    E eu preencho o campo de email com "email_inexistente@aluno.unb.br"
    E eu clico no botão "Enviar solicitação"
    Então eu devo ver a mensagem "Email não encontrado no sistema"
    E nenhum email deve ser enviado

  Cenário: Tentar redefinir senha com token inválido
    Dado que recebi um link de redefinição de senha
    Quando eu acesso um link com token inválido ou expirado
    Então eu devo ver a mensagem "Link inválido ou expirado. Solicite uma nova redefinição de senha"
    E eu devo ser redirecionado para a página de solicitação de redefinição

  Cenário: Tentar redefinir senha com senhas não coincidentes
    Dado que recebi o email com o link de redefinição
    E eu clico no link de redefinição no email
    Quando eu preencho o campo "Nova senha" com "NovaSenha123!"
    E eu preencho o campo "Confirmar senha" com "SenhaDiferente456!"
    E eu clico no botão "Redefinir senha"
    Então eu devo ver a mensagem de erro "As senhas não coincidem"
    E a senha não deve ser alterada

  Cenário: Tentar redefinir senha com senha fraca
    Dado que recebi o email com o link de redefinição
    E eu clico no link de redefinição no email
    Quando eu preencho o campo "Nova senha" com "123"
    E eu preencho o campo "Confirmar senha" com "123"
    E eu clico no botão "Redefinir senha"
    Então eu devo ver a mensagem de erro "A senha deve ter no mínimo 6 caracteres"
    E a senha não deve ser alterada

  Cenário: Tentar usar link de redefinição expirado
    Dado que solicitei a redefinição de senha há mais de 24 horas
    Quando eu clico no link de redefinição no email
    Então eu devo ver a mensagem "Link expirado. Solicite uma nova redefinição de senha"
    E eu devo ser redirecionado para a página de solicitação de redefinição

