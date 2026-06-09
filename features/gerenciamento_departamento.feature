# language: pt

#Issue-11

Funcionalidade: Sistema de gerenciamento por departamento
  Como administrador
  Quero gerenciar os dados de turmas
  A fim de organizar as informações acadêmicas

  Cenário: Caminho feliz
    Dado que existem turmas no departamento do administrador
    Quando o administrador selecionar uma dessas turmas
    Então o sistema deve exibir os dados correspondentes

  Cenário: Caminho triste
    Dado que não existem turmas no departamento ou turma não pertence ao departamento
    Quando o administrador realizar a consulta
    Então o sistema deve informar que não há dados disponíveis
