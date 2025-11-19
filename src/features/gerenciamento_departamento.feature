# language: pt
# features/gerenciamento_por_departamento.feature

Funcionalidade: Gerenciamento de Turmas por Departamento
  Eu como Administrador (Coordenador de Departamento)
  Quero gerenciar somente as turmas do departamento o qual eu pertenço
  A fim de avaliar o desempenho das turmas no semestre atual

  Contexto:
    Dado que eu sou um Administrador coordenador do departamento "Ciência da Computação" (CIC)
    E que estou logado no sistema
    E que existe a turma "Engenharia de Software" (CIC0105) pertencente ao departamento "CIC"
    E que existe a turma "Cálculo 1" (MAT0025) pertencente ao departamento "Matemática" (MAT)

  @happy_path
  Cenário: Coordenador visualiza turmas do seu próprio departamento
    Quando eu acesso a lista de turmas para gerenciamento
    Então eu devo ver a turma "Engenharia de Software" na lista
    E eu devo ver a opção de "Gerenciar" para a turma "Engenharia de Software"

  @sad_path
  Cenário: Coordenador não visualiza turmas de outros departamentos (Isolamento)
    Quando eu acesso a lista de turmas para gerenciamento
    Então eu NÃO devo ver a turma "Cálculo 1" na lista

  @sad_path
  Cenário: Tentativa de acesso direto a turma de outro departamento (Segurança)
    Quando eu tento acessar diretamente a URL de gerenciamento da turma "Cálculo 1"
    Então eu devo ser redirecionado para a minha página inicial
    E eu devo ver a mensagem de erro "Acesso negado: Você não tem permissão para gerenciar turmas de outro departamento."