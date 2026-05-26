# language: pt

Funcionalidade: Sistema de Login
  Como usuário do sistema
  Para que eu possa responder formulários ou gerenciar o sistema
  Eu quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada

  Contexto:
    Dado que existe um usuário discente com e-mail "discente@unb.br" e senha "senha123"
    E que existe um usuário docente com e-mail "docente@unb.br" e senha "senha123"
    E que existe um usuário administrador com e-mail "admin@unb.br" e senha "admin123"
    E que existe um usuário com matrícula "232000000" e senha "senha123"
    E que estou na página de login

  @cenario_feliz
  Esquema do Cenário: Login bem-sucedido de usuários padrão
    Quando preencho "E-mail ou Matrícula" com "<credencial>"
    E preencho "Senha" com "<senha>"
    E clico em "Entrar"
    Então devo ser redirecionado para a página inicial
    E devo ver o menu de navegação

    Exemplos:
      | credencial      | senha    |
      | discente@unb.br | senha123 |
      | docente@unb.br  | senha123 |
      | 232000000       | senha123 |

  @cenario_feliz
  Cenário: Login bem-sucedido como administrador exibe menu de gerenciamento
    Quando preencho "E-mail ou Matrícula" com "admin@unb.br"
    E preencho "Senha" com "admin123"
    E clico em "Entrar"
    Então devo ser redirecionado para a página inicial
    E devo ver o menu de navegação
    E devo ver a opção de gerenciamento no menu lateral

  @cenario_triste
  Esquema do Cenário: Tentativas de login com dados inválidos ou malformados
    Quando preencho "E-mail ou Matrícula" com "<email_inserido>"
    E preencho "Senha" com "<senha_inserida>"
    E clico em "Entrar"
    Então devo permanecer na página de login
    E devo ver a mensagem "<mensagem_esperada>"

    Exemplos:
      | email_inserido   | senha_inserida | mensagem_esperada                     |
      | discente@unb.br  | senhaerrada    | E-mail ou senha inválidos             |
      | naoexiste@unb.br | qualquer123    | E-mail ou senha inválidos             |
      | emailsemarroba   | senha123       | E-mail inválido                       |
      | discente@unb.br  | 123            | E-mail ou senha inválidos             |
      | 232000000        | senhaerrada    | Matrícula ou senha inválidos          |
      | 232000000        | 123            | Matrícula ou senha inválidos          |

  @cenario_triste
  Esquema do Cenário: Validação de campos obrigatórios não preenchidos
    Quando preencho "E-mail ou Matrícula" com "<email_inserido>"
    E preencho "Senha" com "<senha_inserida>"
    E clico em "Entrar"
    Então devo permanecer na página de login
    E devo ver a mensagem "Preencha todos os campos obrigatórios"

    Exemplos:
      | email_inserido  | senha_inserida |
      | ""              | senha123       |
      | discente@unb.br | ""             |
      | ""              | ""             |

  @cenario_triste
  Cenário: Login com usuário inativo
    Dado que existe um usuário inativo com e-mail "inativo@unb.br" e senha "senha123"
    Quando preencho "E-mail ou Matrícula" com "inativo@unb.br"
    E preencho "Senha" com "senha123"
    E clico em "Entrar"
    Então devo permanecer na página de login
    E devo ver a mensagem "Usuário inativo. Entre em contato com o administrador"