# language: pt

Funcionalidade: Criar formulário baseado em template
  Como um administrador
  Quero criar um formulário baseado em um template para as turmas que eu escolher
  A fim de avaliar o desempenho das turmas no semestre atual

  Contexto:
    Dado que eu estou logado como administrador
    E que existe um template chamado "Avaliação Padrão" com as seguintes perguntas:
      | Pergunta                         | Tipo            | Opções                          |
      | Como você avalia o professor?    | Múltipla Escolha | Ótimo, Bom, Regular, Ruim       |
      | Qual seu nível de satisfação?    | Escala          | 1, 2, 3, 4, 5                   |
      | Deixe seu comentário            | Texto           |                                  |
    E que existem as seguintes turmas no semestre "2026.1":
      | Código | Disciplina      | Turma |
      | TEC001 | Matemática      | A     |
      | TEC002 | Português       | B     |
      | TEC003 | História        | A     |

  Cenário: Criar formulário a partir de template para uma turma (Happy Path)
    Quando eu acesso a página de criação de formulário a partir de template
    E eu seleciono o template "Avaliação Padrão"
    E eu seleciono as turmas "TEC001 - Matemática - A"
    E eu clico em "Criar Formulário"
    Então eu devo ver a mensagem "Formulário criado com sucesso"
    E o formulário deve conter as perguntas do template "Avaliação Padrão"
    E o formulário deve estar associado à turma "Matemática - A"

  Cenário: Criar formulário a partir de template para múltiplas turmas (Happy Path)
    Quando eu acesso a página de criação de formulário a partir de template
    E eu seleciono o template "Avaliação Padrão"
    E eu seleciono as turmas "TEC001 - Matemática - A" e "TEC002 - Português - B"
    E eu clico em "Criar Formulário"
    Então eu devo ver a mensagem "Formulários criados com sucesso"
    E deve existir um formulário para a turma "Matemática - A"
    E deve existir um formulário para a turma "Português - B"
    E cada formulário deve conter as perguntas do template "Avaliação Padrão"

  Cenário: Tentar criar formulário sem selecionar template (Sad Path)
    Quando eu acesso a página de criação de formulário a partir de template
    E eu não seleciono nenhum template
    E eu seleciono as turmas "TEC001 - Matemática - A"
    E eu clico em "Criar Formulário"
    Então eu devo ver a mensagem "Selecione um template para criar o formulário"

  Cenário: Tentar criar formulário sem selecionar turmas (Sad Path)
    Quando eu acesso a página de criação de formulário a partir de template
    E eu seleciono o template "Avaliação Padrão"
    E eu não seleciono nenhuma turma
    E eu clico em "Criar Formulário"
    Então eu devo ver a mensagem "Selecione pelo menos uma turma"

  Cenário: Visualizar lista de templates disponíveis antes de criar
    Quando eu acesso a página de criação de formulário a partir de template
    Então eu devo ver a lista de templates disponíveis
    E eu devo ver a lista de turmas do semestre "2026.1" disponíveis