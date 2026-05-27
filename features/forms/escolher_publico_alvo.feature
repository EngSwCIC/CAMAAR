# language: pt
Funcionalidade: Escolher público-alvo do formulário
  Como Administrador
  Quero escolher criar um formulário para os docentes ou os discentes de uma turma
  A fim de avaliar o desempenho de uma matéria

  Contexto:
    Dado que estou autenticado como administrador
    E que selecionei o template "Avaliação Geral de Disciplina"
    E selecionei a turma "Estrutura de Dados - Turma C"

  @happy
  Cenário: Criar formulário direcionado estritamente para os discentes (alunos)
    Dado que estou na etapa de definição de público-alvo
    Quando eu seleciono a opção de público-alvo como "Discentes"
    E confirmo a publicação do formulário
    Então o formulário deve ficar disponível apenas para os alunos matriculados na turma "Estrutura de Dados - Turma C"
    E os docentes da turma não devem ter acesso para responder a este formulário

  @happy
  Cenário: Criar formulário direcionado estritamente para os docentes (professores)
    Dado que estou na etapa de definição de público-alvo
    Quando eu seleciono a opção de público-alvo como "Docentes"
    E confirmo a publicação do formulário
    Então o formulário deve ficar disponível apenas para os professores vinculados à turma "Estrutura de Dados - Turma C"

  @sad
  Cenário: Tentar avançar sem definir o público-alvo do formulário
    Dado que estou na etapa de definição de público-alvo
    Quando eu não seleciono nem "Docentes" e nem "Discentes"
    E clico em "Confirmar Publicação"
    Então eu devo ver o alerta "Por favor, selecione o público-alvo do formulário"
    E o formulário não deve ser publicado