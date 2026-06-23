# language: pt
Funcionalidade: Criação de Formulário de Avaliação de Turma

  Como um Administrador
  Quero escolher criar um formulário para os docentes ou os discentes de uma turma
  A fim de avaliar o desempenho de uma matéria

  Cenário: Criação de formulário com sucesso para discentes
    Dado que eu acesse a tela de "Criação de Formulários"
    Quando eu selecionar a matéria "Cálculo 1" e a turma "1"
    E definir o público-alvo como "Discentes"
    E preencher as perguntas do formulário de avaliação
    E clicar em "Publicar Formulário"
    Então o sistema deve salvar o formulário com sucesso
    E exibir a mensagem "Formulário de avaliação para discentes publicado com sucesso."
    E o formulário deve ficar disponível para os alunos da turma "1" responderem

  Cenário: Tentativa de publicação de formulário sem selecionar o público-alvo
    Dado que eu acesse a tela de "Criação de Formulários"
    Quando eu selecionar a matéria "Cálculo 1" e a turma "1"
    E deixar o campo de público-alvo em branco
    E preencher as perguntas do formulário de avaliação
    E clicar em "Publicar Formulário"
    Então o sistema não deve permitir a publicação
    E deve exibir um alerta impeditivo "Por favor, selecione se o formulário é para Docentes ou Discentes."

  Cenário: Tentativa de criação de formulário sem preencher as perguntas
    Dado que eu acesse a tela de "Criação de Formulários"
    Quando eu selecionar a matéria Cálculo 2" e a turma "3"
    E definir o público-alvo como "Docentes"
    E não adicionar nenhuma pergunta ao formulário
    E clicar em "Publicar Formulário"
    Então o sistema deve bloquear a ação
    E exibir a mensagem de erro "O formulário não pode ser publicado sem perguntas cadastradas."

