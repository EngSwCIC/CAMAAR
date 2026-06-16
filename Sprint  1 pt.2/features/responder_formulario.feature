# language: pt
Funcionalidade: Responder formulário
  Como Participante de uma turma
  Quero responder o questionário sobre a turma em que estou matriculado
  A fim de submeter minha avaliação da turma

  Contexto:
    Dado que o participante está autenticado no sistema
    E acessa o módulo de "Avaliações"

  Cenário: Participante responde formulário com sucesso (Caminho Feliz)
    Dado que existe um formulário disponível para a turma "Engenharia de Software"
    E o participante ainda não respondeu esse formulário
    Quando o participante seleciona o formulário e preenche todas as questões
    E aciona a opção "Enviar Avaliação"
    Então o sistema deve registrar as respostas do participante
    E exibir a mensagem "Avaliação enviada com sucesso"
    E o formulário não deve mais aparecer como pendente

  Cenário: Participante tenta responder formulário já respondido (Caminho Triste)
    Dado que o participante já respondeu o formulário da turma "Engenharia de Software"
    Quando o participante tenta acessar o mesmo formulário novamente
    Então o sistema deve bloquear o acesso ao formulário
    E exibir a mensagem "Você já respondeu este formulário"
