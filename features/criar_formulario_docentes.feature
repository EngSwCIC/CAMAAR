@issue-113 (Criação de formulário para docentes ou discentes)
Funcionalidade: Seleção de Público-Alvo na Criação de Formulário
  Como administrador
  Quero escolher criar um formulário para os docentes ou os discentes de uma turma
  A fim de avaliar o desempenho de uma matéria

  Contexto:
    Dado que existe um template de formulário "Avaliação de Disciplina"
    E existe a turma "CIC101" que possui docentes e discentes
    E o administrador está na tela de criação de formulário

  Cenário: Criação de formulário para discentes (padrão)
    Quando o administrador seleciona o template "Avaliação de Disciplina"
    E seleciona a turma "CIC101"
    E escolhe "Discentes" como público-alvo
    E confirma a criação
    Então o sistema deve criar o formulário e disponibilizá-lo para os discentes de "CIC101"
    E o sistema deve notificar os discentes sobre o novo formulário

  Cenário: Criação de formulário para docentes
    Quando o administrador seleciona um template "Avaliação do Docente"
    E seleciona a turma "CIC101"
    E escolhe "Docentes" como público-alvo
    E confirma a criação
    Então o sistema deve criar o formulário e disponibilizá-lo para os docentes de "CIC101"
    E o sistema deve notificar os docentes responsáveis pela turma

  Cenário: Tentativa de criação sem seleção de público-alvo
    Quando o administrador seleciona o template e a turma
    Mas omite a seleção de "Docentes" ou "Discentes"
    E tenta confirmar a criação
    Então o sistema deve impedir a criação
    E deve exibir a mensagem "O público-alvo do formulário deve ser selecionado"