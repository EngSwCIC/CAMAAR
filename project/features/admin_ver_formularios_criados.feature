# language: pt
Funcionalidade: Visualização dos formulários criados

  Como um Administrador
  Quero visualizar os formulários criados
  A fim de poder gerar um relatório a partir das respostas

  Cenário: Visualização de lista de formulários com sucesso
    Dado que estou logado no sistema como "Administrador"
    Quando eu clico na aba de "Meus Formulários" no menu lateral
    E existem formulários previamente criados por mim no sistema
    Então eu devo ver uma lista com todos os meus formulários publicados
    E a lista deve exibir o título, a turma e o status de cada formulário

  Cenário: Visualização de lista quando nenhum formulário foi criado
    Dado que estou logado no sistema como "Administrador"
    Quando eu clico na aba de "Meus Formulários" no menu lateral
    E eu ainda não criei nenhum formulário no sistema
    Então a lista de formulários deve aparecer vazia
    E o sistema deve exibir a mensagem "Você ainda não possui formulários criados para as suas turmas."