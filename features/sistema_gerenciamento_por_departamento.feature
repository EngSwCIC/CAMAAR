# language: pt

Funcionalidade: Sistema de gerenciamento por departamento
  Como Administrador do sistema
  Eu quero gerenciar somente as turmas do departamento o qual eu pertenço
  Para que eu possa avaliar o desempenho das turmas no semestre atual

  Contexto:
    Dado que estou logado como administrador com email "admin@unb.br"
    E sou administrador do departamento "CIC"
    E existem turmas de diferentes departamentos no sistema:
      | codigo      | nome                    | departamento |
      | CIC0097     | BANCOS DE DADOS         | CIC          |
      | CIC0105     | ENGENHARIA DE SOFTWARE  | CIC          |
      | MAT0101     | CÁLCULO 1               | MAT          |
      | FIS0101     | FÍSICA 1                | FIS          |

  # ========================================
  # CENÁRIOS FELIZES
  # ========================================

  Cenário: Visualizar apenas turmas do meu departamento
    Dado que estou na página de gerenciamento de turmas
    Quando eu acesso a lista de turmas
    Então eu devo ver apenas as turmas do departamento "CIC"
    E devo ver a turma "CIC0097 - BANCOS DE DADOS"
    E devo ver a turma "CIC0105 - ENGENHARIA DE SOFTWARE"
    E não devo ver turmas de outros departamentos
    E devo ver o filtro indicando "Departamento: CIC"

  Cenário: Criar formulário apenas para turmas do meu departamento
    Dado que estou na página de criação de formulário
    E existe um template "Avaliação Semestral"
    Quando eu seleciono o template "Avaliação Semestral"
    E eu acesso a lista de turmas para seleção
    Então eu devo ver apenas as turmas do departamento "CIC"
    E devo poder selecionar a turma "CIC0097"
    E devo poder selecionar a turma "CIC0105"
    E não devo ver turmas de outros departamentos na lista

  Cenário: Visualizar resultados apenas de turmas do meu departamento
    Dado que estou na página de visualização de resultados
    Quando eu acesso a lista de formulários
    Então eu devo ver apenas formulários de turmas do departamento "CIC"
    E devo ver os resultados da turma "CIC0097"
    E devo ver os resultados da turma "CIC0105"
    E não devo ver resultados de turmas de outros departamentos

  Cenário: Filtrar turmas por semestre dentro do meu departamento
    Dado que existem turmas do departamento "CIC" em diferentes semestres
    E estou na página de gerenciamento de turmas
    Quando eu seleciono o filtro de semestre "2021.2"
    E eu clico em "Filtrar"
    Então eu devo ver apenas turmas do departamento "CIC" do semestre "2021.2"
    E não devo ver turmas de outros semestres

  # ========================================
  # CENÁRIOS TRISTES
  # ========================================

  Cenário: Tentar acessar turma de outro departamento
    Dado que estou na página de gerenciamento de turmas
    Quando eu tento acessar diretamente a turma "MAT0101" de outro departamento
    Então eu devo ver a mensagem "Você não tem permissão para acessar esta turma"
    E eu devo ser redirecionado para a página de gerenciamento do meu departamento

  Cenário: Visualizar mensagem quando não há turmas no meu departamento
    Dado que não existem turmas cadastradas para o departamento "CIC"
    E estou na página de gerenciamento de turmas
    Quando eu acesso a lista de turmas
    Então eu devo ver a mensagem "Não há turmas cadastradas para o seu departamento"
    E não devo ver nenhuma turma na lista

  Cenário: Tentar criar formulário para turma de outro departamento
    Dado que estou na página de criação de formulário
    E existe um template "Avaliação Semestral"
    Quando eu tento selecionar uma turma de outro departamento através de manipulação de URL
    Então eu devo ver a mensagem "Você não tem permissão para criar formulários para esta turma"
    E o formulário não deve ser criado

