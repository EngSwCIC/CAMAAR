# language: pt
Funcionalidade: Visualização de formulários para responder
  Como Participante de uma turma
  Quero visualizar os formulários não respondidos das turmas em que estou matriculado
  A fim de poder escolher qual irei responder

  Contexto:
    Dado que o participante está autenticado no sistema
    E acessa o módulo de "Avaliações"

  Cenário: Participante visualiza formulários pendentes (Caminho Feliz)
    Dado que existem formulários não respondidos nas turmas do participante
    Quando o participante acessa a lista de formulários pendentes
    Então o sistema deve exibir todos os formulários não respondidos
    E cada formulário deve mostrar o nome da turma e o prazo de resposta

  Cenário: Participante acessa lista sem formulários pendentes (Caminho Triste)
    Dado que o participante já respondeu todos os formulários disponíveis
    Quando o participante acessa a lista de formulários pendentes
    Então o sistema deve exibir a mensagem "Não há formulários pendentes no momento"
