# language: pt

Funcionalidade: Cadastrar Usuários do Sistema
  Como Administrador do sistema
  Eu quero solicitar definição de senha para participantes importados do SIGAA
  Para que eles possam acessar o sistema CAMAAR

  Contexto:
    Dado que estou logado como administrador com email "admin@unb.br"
    E foram importados os seguintes usuários do SIGAA:
      | matricula | nome          | email               | tipo      |
      | 123456    | João Silva    | joao@aluno.unb.br   | aluno     |
      | 789012    | Maria Santos  | maria@aluno.unb.br  | aluno     |
      | 456789    | Prof. Carlos  | carlos@unb.br       | professor |

  # CENÁRIOS FELIZES

  Cenário: Enviar convite de cadastro para usuário importado
    Dado que o usuário "João Silva" foi importado mas não definiu senha
    Quando eu acesso a página de gerenciamento de usuários
    E eu seleciono o usuário "João Silva"
    E eu clico em "Enviar Convite de Cadastro"
    Então eu devo ver "Convite enviado com sucesso para joao@aluno.unb.br"
    E o usuário deve receber um email com link de definição de senha
    E o link deve expirar em 48 horas
     E o status do usuário deve mudar para "Convite Enviado"


  # CENÁRIOS TRISTES

  Cenário: Tentar enviar convite para usuário já ativo
    Dado que o usuário "Prof. Carlos" tem status "Ativo"
    Quando eu tento enviar convite para este usuário
    Então eu devo ver "Este usuário já possui cadastro ativo"