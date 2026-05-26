Funcionalidade: Definir senha da conta

Como um usuário do sistema
Quero definir uma senha para minha conta através do e-mail de solicitação de cadastro
Para que eu possa acessar o sistema

Contexto:
  Dado que uma solicitação de cadastro foi enviada para "user@unb.br"
  E que eu recebi o e-mail de ativação da conta
  E que estou na página de definição de senha

Cenário: Definir senha com sucesso (happy path)
  Quando eu preencho "Senha" com "StrongPass123"
  E eu preencho "Confirmar Senha" com "StrongPass123"
  E eu clico em "Salvar Senha"
  Então eu devo ver "Senha definida com sucesso"
  E devo ser redirecionado para a página de login

Cenário: Tentar definir senha com confirmação diferente (sad path)
  Quando eu preencho "Senha" com "StrongPass123"
  E eu preencho "Confirmar Senha" com "WrongPass456"
  E eu clico em "Salvar Senha"
  Então devo permanecer na página de definição de senha
  E devo ver "As senhas não coincidem"
