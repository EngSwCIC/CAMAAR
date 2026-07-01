# language: pt
Funcionalidade: Editar e deletar template sem afetar formulários já criados
  Como Administrador
  Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
  A fim de organizar os templates existentes

  Contexto:
    Dado que existe um usuário administrador cadastrado no sistema

  @happy
  Cenário: Administrador edita um template criado por ele
    Dado que estou autenticado como administrador
    E que existe um template chamado "Avaliação de Disciplina" criado por mim
    Quando eu acesso a página de edição do template "Avaliação de Disciplina"
    E altero o título do template para "Avaliação Semestral de Disciplina"
    E altero a descrição do template para "Template atualizado para avaliação semestral"
    E confirmo a atualização do template
    Então devo ver uma mensagem informando que o template foi atualizado com sucesso
    E devo ver o template "Avaliação Semestral de Disciplina" na lista de templates

  @happy
  Cenário: Administrador deleta um template criado por ele
    Dado que estou autenticado como administrador
    E que existe um template chamado "Avaliação de Disciplina" criado por mim
    Quando eu acesso a página de templates
    E solicito a exclusão do template "Avaliação de Disciplina"
    E confirmo a exclusão do template
    Então devo ver uma mensagem informando que o template foi removido com sucesso
    E não devo ver o template "Avaliação de Disciplina" na lista de templates

  @happy
  Cenário: Editar template não altera formulário já criado
    Dado que estou autenticado como administrador
    E que existe um template chamado "Avaliação de Disciplina" criado por mim
    E que o template "Avaliação de Disciplina" possui a questão "Como você avalia a didática do professor?"
    E que existe um formulário criado a partir do template "Avaliação de Disciplina"
    Quando eu acesso a página de edição do template "Avaliação de Disciplina"
    E altero a questão "Como você avalia a didática do professor?" para "Como você avalia a organização da disciplina?"
    E confirmo a atualização do template
    Então devo ver uma mensagem informando que o template foi atualizado com sucesso
    E o formulário criado anteriormente deve continuar contendo a questão "Como você avalia a didática do professor?"
    E o formulário criado anteriormente não deve conter a questão "Como você avalia a organização da disciplina?"

  @happy
  Cenário: Deletar template não remove formulário já criado
    Dado que estou autenticado como administrador
    E que existe um template chamado "Avaliação de Disciplina" criado por mim
    E que existe um formulário chamado "Formulário de Avaliação de Cálculo 1" criado a partir do template "Avaliação de Disciplina"
    Quando eu acesso a página de templates
    E solicito a exclusão do template "Avaliação de Disciplina"
    E confirmo a exclusão do template
    Então devo ver uma mensagem informando que o template foi removido com sucesso
    E o formulário "Formulário de Avaliação de Cálculo 1" deve continuar existindo

  @sad
  Cenário: Usuário não administrador tenta editar um template
    Dado que existe um template chamado "Avaliação de Disciplina"
    E que existe um usuário não administrador cadastrado no sistema
    E que estou autenticado como usuário não administrador
    Quando eu tento acessar a página de edição do template "Avaliação de Disciplina"
    Então devo ver uma mensagem informando que não tenho permissão para editar templates

  @sad
  Cenário: Usuário não administrador tenta deletar um template
    Dado que existe um template chamado "Avaliação de Disciplina"
    E que existe um usuário não administrador cadastrado no sistema
    E que estou autenticado como usuário não administrador
    Quando eu tento excluir o template "Avaliação de Disciplina"
    Então devo ver uma mensagem informando que não tenho permissão para deletar templates
    E o template "Avaliação de Disciplina" deve continuar existindo
