#language: pt
Funcionalidade: Visualização de resultados no CAMAAR
  Eu como Administrador
  Quero visualizar os formulários criados
  A fim de poder gerar um relatório a partir das respostas

  Contexto:
    Dado que eu estou logado como admin

  Cenário: Visualizar formulários respondidos como admin (HAPPY)
    E que existem 2 formulários respondidos
    E que eu estou na página de resultados do CAMAAR
    Então eu devo ver 2 formulários

  Cenário: Não visualizar formulários respondidos quando não houver nenhum (SAD)
    E que existem 0 formulários
    E que eu estou na página de resultados do CAMAAR
    Então eu devo ver 0 formulários

  Cenário: Formulário inválido (SAD)
    E que existem 1 formulários não respondidos
    E que existem 1 formulários inválidos
    E que eu estou na página de resultados do CAMAAR
    Então eu devo ver 1 formulários
    E eu devo ver "Um ou mais formulários estão incompatíveis e não podem ser visualizados"