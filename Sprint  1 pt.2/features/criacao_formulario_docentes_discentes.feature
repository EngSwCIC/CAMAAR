# language: pt
Funcionalidade: Criação de formulário para docentes ou discentes
  Como Administrador
  Quero escolher criar um formulário para os docentes ou os discentes de uma turma
  A fim de avaliar o desempenho de uma matéria

  Contexto:
    Dado que o administrador está autenticado no sistema
    E acessa o módulo de "Gerenciamento"

  Cenário: Administrador cria formulário para discentes com sucesso (Caminho Feliz)
    Dado que existe um template de formulário cadastrado no sistema
    E existe uma turma cadastrada com discentes matriculados
    Quando o administrador seleciona o template, escolhe o destinatário "Discentes"
    E seleciona a turma "Engenharia de Software - 2026/1"
    E define o período de resposta e aciona "Criar Formulário"
    Então o sistema deve criar o formulário e disponibilizá-lo para os discentes da turma
    E exibir a mensagem "Formulário criado com sucesso"

  Cenário: Administrador tenta criar formulário sem selecionar destinatário (Caminho Triste)
    Dado que existe um template de formulário cadastrado no sistema
    Quando o administrador seleciona o template mas não escolhe o destinatário
    E aciona "Criar Formulário"
    Então o sistema deve rejeitar a criação
    E exibir a mensagem de validação "Selecione o destinatário do formulário: Docentes ou Discentes"
