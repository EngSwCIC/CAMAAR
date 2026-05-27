# language: pt

Funcionalidade: Responder Formulário
  Como estudante matriculado em uma turma
  Quero responder um formulário de avaliação disponibilizado pelo professor
  Para que minha avaliação seja registrada no sistema

  Cenário: Estudante responde formulário com sucesso
    Dado que estou logado como estudante
    E existe um formulário disponível para minha turma
    Quando acesso o formulário e preencho todas as questões
    E clico em "Enviar respostas"
    Então minha resposta é registrada no sistema
    E vejo uma mensagem de confirmação de envio

  Cenário: Estudante tenta responder formulário sem preencher todas as questões
    Dado que estou logado como estudante
    E existe um formulário disponível para minha turma
    Quando acesso o formulário e deixo questões obrigatórias sem resposta
    E clico em "Enviar respostas"
    Então o sistema não registra a resposta
    E vejo uma mensagem de erro indicando campos obrigatórios não preenchidos

  Cenário: Estudante tenta acessar formulário fora do prazo
    Dado que estou logado como estudante
    E existe um formulário cuja data de encerramento já passou
    Quando tento acessar o formulário
    Então o sistema não permite o acesso ao formulário
    E vejo uma mensagem informando que o prazo de resposta foi encerrado

  Cenário: Estudante tenta responder formulário de turma em que não está matriculado
    Dado que estou logado como estudante
    E existe um formulário disponível para uma turma em que não estou matriculado
    Quando tento acessar o formulário diretamente pela URL
    Então o sistema nega o acesso
    E vejo uma mensagem de erro informando que não tenho permissão para responder este formulário
