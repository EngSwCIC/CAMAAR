# language: pt

Funcionalidade: Sistema de definição de senha
  Como Usuário do sistema
  Eu quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro
  Para que eu possa acessar o sistema

  Contexto:
    Dado que fui importado do SIGAA com email "usuario@aluno.unb.br"
    E recebi um email de convite para cadastro no sistema
    E ainda não defini minha senha

  # ========================================
  # CENÁRIOS FELIZES
  # ========================================

  Cenário: Definir senha com sucesso através do link do email
    Dado que recebi o email de convite para cadastro
    Quando eu clico no link de definição de senha no email
    E eu preencho o campo "Senha" com "MinhaSenha123!"
    E eu preencho o campo "Confirmar senha" com "MinhaSenha123!"
    E eu clico no botão "Definir senha"
    Então eu devo ver a mensagem "Senha definida com sucesso. Você já pode fazer login"
    E eu devo ser redirecionado para a página de login
    E minha conta deve estar ativa no sistema
    E eu devo poder fazer login com o email e a senha definida

  Cenário: Definir senha usando matrícula no link
    Dado que recebi o email de convite para cadastro
    E o link contém minha matrícula "123456"
    Quando eu clico no link de definição de senha no email
    E eu preencho o campo "Senha" com "SenhaSegura456!"
    E eu preencho o campo "Confirmar senha" com "SenhaSegura456!"
    E eu clico no botão "Definir senha"
    Então eu devo ver a mensagem "Senha definida com sucesso. Você já pode fazer login"
    E minha conta deve estar ativa no sistema

  # ========================================
  # CENÁRIOS TRISTES
  # ========================================

  Cenário: Tentar definir senha com link inválido
    Dado que recebi um link de definição de senha
    Quando eu acesso um link com token inválido ou expirado
    Então eu devo ver a mensagem "Link inválido ou expirado. Solicite um novo convite"
    E eu devo ser redirecionado para uma página informando que preciso solicitar novo convite

  Cenário: Tentar definir senha com senhas não coincidentes
    Dado que recebi o email de convite para cadastro
    E eu clico no link de definição de senha no email
    Quando eu preencho o campo "Senha" com "MinhaSenha123!"
    E eu preencho o campo "Confirmar senha" com "SenhaDiferente456!"
    E eu clico no botão "Definir senha"
    Então eu devo ver a mensagem de erro "As senhas não coincidem"
    E a senha não deve ser definida
    E eu devo permanecer na página de definição de senha

  Cenário: Tentar definir senha com senha muito curta
    Dado que recebi o email de convite para cadastro
    E eu clico no link de definição de senha no email
    Quando eu preencho o campo "Senha" com "123"
    E eu preencho o campo "Confirmar senha" com "123"
    E eu clico no botão "Definir senha"
    Então eu devo ver a mensagem de erro "A senha deve ter no mínimo 6 caracteres"
    E a senha não deve ser definida

  Cenário: Tentar definir senha com campos vazios
    Dado que recebi o email de convite para cadastro
    E eu clico no link de definição de senha no email
    Quando eu deixo o campo "Senha" vazio
    E eu deixo o campo "Confirmar senha" vazio
    E eu clico no botão "Definir senha"
    Então eu devo ver a mensagem de erro "Todos os campos são obrigatórios"
    E a senha não deve ser definida

  Cenário: Tentar usar link de definição de senha expirado
    Dado que recebi o email de convite há mais de 48 horas
    Quando eu clico no link de definição de senha no email
    Então eu devo ver a mensagem "Link expirado. Solicite um novo convite de cadastro"
    E eu devo ser redirecionado para uma página informando que preciso solicitar novo convite

  Cenário: Tentar definir senha para usuário que já possui senha
    Dado que já defini minha senha anteriormente
    E recebi um novo email de convite
    Quando eu clico no link de definição de senha no email
    Então eu devo ver a mensagem "Este usuário já possui senha cadastrada. Faça login ou use a opção de redefinição de senha"
    E eu devo ser redirecionado para a página de login

