# language: pt

Funcionalidade: Responder formulário

  Como participante de uma turma
  Quero responder o questionário sobre uma turma em que estou matriculado
  Para submeter minha avaliação da turma

  Cenário: Responder e submeter um questionário de avaliação
    Dado que estou na página "avaliações" logado como aluno
    E estou matriculado em turma com questionário de avaliação não respondido
    E selecionei o primeiro
    E preenchi
    E cliquei em cancelar
    Então o formulário continua presente na tela para ser preenchido do zero
    E escolhi, preenchi e cliquei em enviar
    Então o mesmo formulário deve aparecer desabilitado
    E uma mensagem informando sucesso ao enviar formulário
