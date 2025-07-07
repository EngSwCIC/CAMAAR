# language: pt

Funcionalidade: Gerenciamento de turmas por departamento

  Como Administrador
  Quero Gerenciar somente as turmas do departamento ao qual pertenço
  Para avaliar o desempenho das turmas no semestre atual

  Cenário: Visualizar apenas turmas do meu departamento
    Dado que estou logado como administrador
    E pertenço a um departamento específico
    Quando acesso a seção de "Gerenciamento de Turmas"
    Então devo visualizar somente as turmas vinculadas ao meu departamento
    E devo poder acessar os formulários de avaliação dessas turmas

  Cenário: Visualizar apenas turmas do meu departamento (sem departamento)
    Dado que estou logado como administrador
    E não pertenço a um departamento específico
    Então a seção de "Gerenciamento de Turmas" não deve estar habilitada
