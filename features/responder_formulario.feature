# arquivo de especificação da issue "Responder formulário" (Sprint 1)
@issue-99
Feature: Responder questionário
  Como participante de uma turma
  Quero responder o questionário da turma em que estou matriculado
  A fim de submeter minha avaliação

  Cenário: Envio de avaliação completo (feliz)
    Dado que o participante acessa o questionário da turma
    E preenche as respostas obrigatórias
    Quando envia o questionário
    Então o sistema deve registrar a avaliação

  Cenário: Envio com campos obrigatórios em branco (triste)
    Dado que o participante acessa o questionário da turma
    E deixa perguntas obrigatórias sem resposta
    Quando tenta enviar o questionário
    Então o sistema deve rejeitar o envio
