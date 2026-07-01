# language: pt
Funcionalidade: Criar formulário de avaliação
  Como Administrador
  Quero criar um formulário de avaliação a partir de um template
  A fim de disponibilizar a avaliação para os alunos de uma turma específica

  Contexto:
    Dado que o administrador está autenticado no sistema CAMAAR
    E acessa o menu de "Nova Avaliação"

  Cenário: Criação bem-sucedida de um formulário de avaliação (Caminho Feliz)
    Quando o administrador seleciona a turma "Engenharia de Software"
    E seleciona o template "Avaliação Padrão de Turma"
    E define a data de expiração para "30/06/2026"
    E clica em "Gerar Formulário"
    Então o sistema deve vincular o formulário à turma
    E exibir a mensagem de sucesso "Formulário de avaliação gerado e disponibilizado aos alunos"

  Cenário: Tentativa de criar formulário sem definir a data de expiração (Caminho Triste)
    Quando o administrador seleciona a turma "Engenharia de Software"
    E seleciona o template "Avaliação Padrão de Turma"
    E deixa o campo de data de expiração em branco
    E clica em "Gerar Formulário"
    Então o sistema deve bloquear a criação
    E exibir a mensagem de erro "A data de expiração é obrigatória"