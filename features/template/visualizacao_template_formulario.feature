# language: pt
Funcionalidade: Visualização dos templates criados
  Como um Administrador
  Quero visualizar os templates criados
  A fim de poder editar e/ou deletar um template que eu criei

  @cenario_feliz
  Cenário: Administrador visualiza a lista de templates com sucesso (Cenário Feliz)
    Dado que existem os seguintes templates cadastrados no sistema:
      | titulo                     | descricao                   |
      | Avaliação Docente Padrão   | Avaliação semestral de UnB  |
      | Feedback de Infraestrutura | Avaliação de laboratórios   |
    E que estou logado como um usuário Administrador
    Quando acesso a página de gerenciamento de templates
    Então devo ver uma lista contendo todos os templates cadastrados
    E devo visualizar o template "Avaliação Docente Padrão"
    E devo visualizar o template "Feedback de Infraestrutura"

  @cenario_triste
  Cenário: Administrador acessa a listagem mas não há templates cadastrados (Cenário Triste — Lista Vazia)
    Dado que não existem templates cadastrados no sistema
    E que estou logado como um usuário Administrador
    Quando acesso a página de gerenciamento de templates
    Então devo ver a mensagem "Nenhum template de formulário foi encontrado."

  @cenario_triste
  Cenário: Usuário comum tenta visualizar os templates sem permissão (Cenário Triste — Sem Permissão)
    Dado que estou logado como um usuário "Participante de uma turma"
    Quando tento acessar a página de gerenciamento de templates através da URL "/templates"
    Então devo ser redirecionado para a página inicial
    E devo ver uma mensagem de alerta "Acesso negado. Esta área é restrita para administradores."