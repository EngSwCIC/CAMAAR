# language: pt

@issue-106
Funcionalidade: Gerenciamento de turmas por departamento
  Como administrador
  Quero visualizar e gerenciar apenas as turmas do meu departamento
  Para avaliar o desempenho das turmas no semestre atual

  Contexto:
    Dado que existe um administrador cadastrado no departamento "Computação"
    E existe uma turma "CIC101 - Turma A" do departamento "Computação"
    E existe uma turma "MAT001 - Turma B" do departamento "Matemática"
    E o administrador está autenticado no sistema
    E o administrador acessa a área de gerenciamento de turmas

  Cenário: Listar apenas turmas do departamento do administrador
    Quando o administrador visualiza a lista de turmas disponíveis para gerenciamento
    Então o sistema deve exibir a turma "CIC101 - Turma A"
    E o sistema não deve exibir a turma "MAT001 - Turma B"

  Cenário: Gerenciar turma do próprio departamento
    Quando o administrador seleciona a turma "CIC101 - Turma A"
    E acessa os dados de desempenho da turma no semestre atual
    Então o sistema deve permitir a visualização dos indicadores de desempenho
    E deve permitir que o administrador registre ou edite avaliações da turma

  Cenário: Tentativa de acesso a turma de outro departamento
    Quando o administrador tenta acessar diretamente a turma "MAT001 - Turma B" por URL ou atalho
    Então o sistema não deve permitir o acesso aos dados da turma
    E deve exibir uma mensagem informando que a turma pertence a outro departamento
    E deve redirecionar o administrador para a lista de turmas do seu departamento