# language: pt
# features/visualizacao_formularios_nao_respondidos.feature

Funcionalidade: Visualização de formulários não respondidos
  Eu como Participante de uma turma
  Quero visualizar os formulários não respondidos das turmas em que estou matriculado
  A fim de escolher qual formulário irei responder

Contexto:
  Dado que eu sou um "participante" logado no sistema

@happy_path
Cenário: Exibir formulários não respondidos das turmas em que participo
  Dado que estou na página "dashboard"
  E estou matriculado nas turmas "BD 2025.1" e "Cálculo 2 2025.1"
  E a turma "BD 2025.1" possui os formulários "Avaliação Docente" e "Avaliação da Infraestrutura"
  E eu já respondi apenas o formulário "Avaliação Docente"
  Quando eu acesso a página "formularios/pendentes"
  Então eu devo ver o formulário "Avaliação da Infraestrutura"
  E eu não devo ver o formulário "Avaliação Docente"

@sad_path
Cenário: Participante não possui nenhum formulário pendente
  Dado que estou na página "dashboard"
  E estou matriculado na turma "Engenharia de Software 2025.1"
  E todos os formulários desta turma já foram respondidos por mim
  Quando eu acesso a página "formularios/pendentes"
  Então eu devo ver a mensagem "Nenhum formulário pendente"
  E não devo ver lista de formulários

@sad_path
Cenário: Participante tenta acessar página de pendentes sem estar matriculado em nenhuma turma
  Dado que estou na página "dashboard"
  E não estou matriculado em nenhuma turma
  Quando eu acesso a página "formularios/pendentes"
  Então eu devo ver a mensagem "Você não possui turmas cadastradas"
  E devo permanecer na página "formularios/pendentes"

