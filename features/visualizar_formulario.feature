#language: pt
Funcionalidade: Visualização de formulários para responder
  Eu como Participante de uma turma
  Quero visualizar os formulários não respondidos das turmas em que estou matriculado
  A fim de poder escolher qual irei responder

  Contexto:
    Dado que eu estou logado como aluno

  Cenário: Existem formulários não respondidos HAPPY
    E que existem 2 formulários não respondidos
    E que eu estou na página de avaliação do CAMAAR
    Então eu devo ver 2 formulários

  Cenário: Não existem formulários não respondidos HAPPY
    E que existem 0 formulários não respondidos
    E que eu estou na página de avaliação do CAMAAR
    Então eu devo ver 0 formulários

  Cenário: Formulário inválido SAD
    E que existem 1 formulários inválidos
    E que eu estou na página de avaliação do CAMAAR
    Então eu devo ver 0 formulários
    E eu devo ver "Um ou mais formulários estão incompatíveis e não podem ser visualizados"