# language: pt

Funcionalidade: Criação de formulários baseados em template

  Como administrador
  Quero criar um formulário baseado em um template para as turmas selecionadas
  Para avaliar o desempenho das turmas no semestre atual

  Cenário: Criar formulário para turmas selecionadas com sucesso
    Dado que estou logado como administrador
    E tenho templates de formulários disponíveis
    E escolhi um template
    E escolhi as turmas para aplicar o formulário
    Quando clicar em "Enviar"
    Então o formulário deve ficar disponível para as turmas selecionadas
    E aparecer na página "Avaliações"
    E uma mensagem deve aparecer confirmando a criação com sucesso

  Cenário: Turma selecionada já tem formulário em aberto
    Dado que estou logado como administrador
    E tenho templates de formulários disponíveis
    E escolhi um template
    E escolhi uma turma que já possui formulário em aberto
    Quando clicar em "Enviar"
    Então uma mensagem de alerta deve aparecer indicando que a turma já possui formulário em aberto
