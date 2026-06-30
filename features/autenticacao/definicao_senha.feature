# language: pt

Funcionalidade: Sistema de definição de senha
  Como usuário
  Para que eu possa acessar o sistema
  Eu quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro

  Contexto:
    Dado que existe um usuário cadastrado pelo administrador com e-mail "novo@unb.br" sem senha definida
    E que esse usuário recebeu um e-mail com link de definição de senha

  @cenario_feliz
  Cenário: Definição de senha bem-sucedida
    Dado que possuo um token de definição de senha válido
    Quando acesso a página de definição de senha
    E preencho "Nova senha" com "senha123"
    E preencho "Confirmar senha" com "senha123"
    E clico em "Definir senha"
    Então devo ser redirecionado para a minha página inicial
    E devo ver a mensagem "Senha definida com sucesso. Bem-vindo!"

  @cenario_triste
  Esquema do Cenário: Validações de senha com token válido
    Dado que possuo um token de definição de senha válido
    E que acesso a página de definição de senha
    Quando preencho "Nova senha" com "<nova_senha>"
    E preencho "Confirmar senha" com "<confirmacao>"
    E clico em "Definir senha"
    Então devo permanecer na página de definição de senha
    E devo ver a mensagem "<mensagem>"

    Exemplos:
      | nova_senha         | confirmacao        | mensagem                                      |
      | senha123           | senha456           | As senhas não coincidem                       |
      | 123                | 123                | Senha deve ter no mínimo 6 caracteres         |
      | somenteminusculas  | somenteminusculas  | A senha deve conter pelo menos um número      |
      | Senha123           | Senha123           | A senha deve conter apenas letras minúsculas  |

  @cenario_triste
  Esquema do Cenário: Campos obrigatórios na definição de senha
    Dado que possuo um token de definição de senha válido
    E que acesso a página de definição de senha
    Quando preencho "Nova senha" com "<nova_senha>"
    E preencho "Confirmar senha" com "<confirmacao>"
    E clico em "Definir senha"
    Então devo permanecer na página de definição de senha
    E devo ver a mensagem "Preencha todos os campos obrigatórios"

    Exemplos:
      | nova_senha | confirmacao |
      | ""        | senha123    |
      | senha123  | ""          |
      | ""        | ""          |

  @cenario_triste
  Cenário: Token de definição de senha expirado
    Dado que possuo um token de definição de senha que expirou há 24 horas
    Quando acesso a página de definição de senha
    Então devo ver a mensagem "Link expirado. Solicite um novo e-mail de cadastro ao administrador"
    E não devo ver o formulário de definição de senha

  @cenario_triste
  Cenário: Token de definição de senha inválido
    Dado que possuo um token de definição de senha inválido ou corrompido
    Quando acesso a página de definição de senha
    Então devo ver a mensagem "Link inválido"
    E não devo ver o formulário de definição de senha

  @cenario_triste
  Cenário: Token já utilizado
    Dado que possuo um token de definição de senha que já foi processado
    Quando acesso a página de definição de senha
    Então devo ver a mensagem "Este link já foi utilizado. Faça login normalmente"
    E não devo ver o formulário de definição de senha