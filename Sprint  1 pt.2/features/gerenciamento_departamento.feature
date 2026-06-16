# language: pt
Funcionalidade: Sistema de gerenciamento por departamento
  Como Administrador
  Quero gerenciar apenas as turmas do departamento ao qual pertenço
  A fim de avaliar o desempenho das turmas do meu departamento no semestre vigente

  Contexto:
    Dado que o administrador está autenticado no sistema
    E acessa o módulo de "Gerenciamento"

  Cenário: Administrador visualiza apenas as turmas do seu departamento (Caminho Feliz)
    Dado que o administrador pertence ao departamento "CIC"
    E existem turmas cadastradas dos departamentos "CIC" e "MAT"
    Quando o administrador acessa a listagem de turmas
    Então o sistema deve exibir apenas as turmas do departamento "CIC"
    E não deve exibir turmas de outros departamentos

  Cenário: Administrador tenta acessar turmas de outro departamento (Caminho Triste)
    Dado que o administrador pertence ao departamento "CIC"
    Quando o administrador tenta acessar diretamente uma turma do departamento "MAT"
    Então o sistema deve bloquear o acesso
    E exibir a mensagem "Você não tem permissão para gerenciar turmas de outro departamento"
