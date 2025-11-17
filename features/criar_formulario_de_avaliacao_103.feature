# language: pt

Funcionalidade: Criar Formulário de Avaliação
  Como Administrador do sistema
  Eu quero criar formulários de avaliação baseados em templates existentes
  Para que eu possa avaliar o desempenho das turmas no semestre atual

  Contexto:
    Dado que estou logado como administrador com email "admin@unb.br"
    E existe um template chamado "Avaliação Semestral" com 5 questões
    E existem as seguintes turmas cadastradas:
      | codigo      | nome                    | semestre |
      | CIC0097 | BANCOS DE DADOS    | 2021.2   |
      | CIC0105 | ENGENHARIA DE SOFTWARE     | 2021.2   |
      | CIC0202 | PROGRAMAÇÃO CONCORRENTE | 2021.2   |

  # ========================================
  # CENÁRIOS FELIZES
  # ========================================

  Cenário: Criar formulário para uma turma com sucesso
    Dado que estou na página de gerenciamento
    Quando eu clico no botão "Enviar Formulários"
    E eu seleciono o template "Avaliação Semestral"
    E eu seleciono a turma "CIC0097"
    E ela tem o semestre "2021.2"
    E eu clico no botão "Enviar"
    Então eu devo ver a mensagem "Formulário de avaliação enviado com sucesso"
    E o formulário deve estar disponível para a turma "CIC0097"
    E o formulário deve conter as 5 questões do template


  # ========================================
  # CENÁRIOS TRISTES
  # ========================================

  Cenário: Tentar criar formulário sem selecionar template
    Dado que estou na página de gerenciamento
    Quando clico no botão "Enviar Formulários"
    E eu seleciono a turma "CIC0105"
    E ela tem o semestre "2021.2"
    E eu clico em "Enviar"
    Então eu devo ver a mensagem de erro "Template é obrigatório"
    E nenhum formulário deve ser criado
    E eu devo permanecer na página de gerenciamento