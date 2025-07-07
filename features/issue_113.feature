#language: pt

Funcionalidade: Criação de formulário para docentes ou discentes

  Como administrador
  Quero escolher criar um formulário para os docentes ou discentes de uma turma
  Para avaliar o desempenho de uma matéria

  Cenário: Criar novo formulário para avaliação de desempenho
    Dado que estou logado como administrador
    E tenho algum template criado
    Quando clico em "Enviar formulários"
    E escolho um template
    E seleciono turmas ou docentes
    E clico em "enviar"
    Então na página de avaliações deve aparecer o formulário correspondente

  Cenário: Criar formulários sem templates existentes
    Dado que estou logado como administrador
    E não possuo templates criados
    Então o botão "Enviar formulários" está desabilitado