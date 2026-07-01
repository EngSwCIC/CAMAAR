# language: pt
Funcionalidade: Responder questionário da turma
  Como Participante de uma turma
  Quero responder o questionário sobre a turma em que estou matriculado
  A fim de submeter minha avaliação da turma

  Contexto:
    Dado que existe um usuário participante cadastrado no sistema

  @happy
  Cenário: Participante responde todas as questões obrigatórias com sucesso
    Dado que estou autenticado como participante
    E que estou na página de resposta do formulário da turma "Cálculo 1"
    Quando eu preencho todas as questões obrigatórias
    E confirmo o envio da avaliação
    Então devo ver uma mensagem informando que a avaliação foi registrada com sucesso
    E o formulário da turma "Cálculo 1" não deve mais aparecer na lista de pendentes

  @sad
  Cenário: Participante tenta enviar resposta incompleta
    Dado que estou autenticado como participante
    E que estou na página de resposta do formulário da turma "Cálculo 1"
    Quando eu deixo uma questão obrigatória em branco
    E confirmo o envio da avaliação
    Então devo ver uma mensagem informando que todas as questões obrigatórias devem ser preenchidas
    E a avaliação não deve ser registrada

  @sad
  Cenário: Participante tenta responder formulário já respondido
    Dado que estou autenticado como participante
    E que já respondi o formulário da turma "Cálculo 1" anteriormente
    Quando eu tento acessar a página de resposta do formulário da turma "Cálculo 1"
    Então devo ver uma mensagem informando que esta avaliação já foi respondida