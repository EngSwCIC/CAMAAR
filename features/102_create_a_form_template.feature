# language: pt
# features/criar_template_formulario.feature

Funcionalidade: Criar template de formulário (#102)
  Como Administrador
  Quero criar um template de formulário contendo as questões do formulário
  A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

  Contexto:
    Dado que estou autenticado como administrador
    E estou na página "gerenciamento/templates" do sistema

  @happy
  Cenário: Criar template com questões dos três tipos (numérica 1-5, múltipla escolha e texto)
    Quando eu abro o modal "Novo template"
    E preencho o nome do template com "Template Avaliação 2025.1"
    E adiciono a questão 1 do tipo "numérica (1-5)" com o texto "Satisfação geral"
    E adiciono a questão 2 do tipo "múltipla escolha" com o texto "Infraestrutura" e as opções:
      | Muito bom |
      | Bom       |
      | Regular   |
      | Ruim      |
    E adiciono a questão 3 do tipo "texto" com o texto "Sugestões"
    E clico em "Criar"
    Então devo ver a mensagem "Template criado com sucesso"
    E devo ver o card do template "Template Avaliação 2025.1" na listagem

  @happy
  Cenário: Manter a ordem das questões após salvar
    Dado que preenchi o modal com três questões em ordem
    Quando eu clico em "Criar"
    Então ao abrir o template salvo devo ver as questões na mesma ordem

  @sad
  Cenário: Tentar criar template sem nome
    Quando eu abro o modal "Novo template"
    E adiciono a questão 1 do tipo "texto" com o texto "Comentário"
    E clico em "Criar"
    Então devo ver a mensagem "Informe o nome do template"
    E o template não é criado

  @sad
  Cenário: Múltipla escolha sem opções
    Quando eu abro o modal "Novo template"
    E preencho o nome do template com "Template Sem Opções"
    E adiciono a questão 1 do tipo "múltipla escolha" com o texto "Escolha uma opção" e nenhuma opção
    E clico em "Criar"
    Então devo ver a mensagem "Adicione pelo menos duas opções"
    E o template não é criado

  @sad
  Cenário: Template sem nenhuma questão
    Quando eu abro o modal "Novo template"
    E preencho o nome do template com "Template Vazio"
    E clico em "Criar"
    Então devo ver a mensagem "Adicione pelo menos uma questão"
    E o template não é criado

  @sad
  Cenário: Nome duplicado no mesmo semestre
    Dado que já existe um template chamado "Template Avaliação 2025.1" no semestre "2025.1"
    Quando eu abro o modal "Novo template"
    E preencho o nome do template com "Template Avaliação 2025.1"
    E adiciono a questão 1 do tipo "texto" com o texto "Q1"
    E clico em "Criar"
    Então devo ver a mensagem "Já existe um template com esse nome no semestre selecionado"
    E o template não é criado

  @sad
  Cenário: Questão numérica fora da escala 1-5 (regra de negócio)
    Quando eu abro o modal "Novo template"
    E preencho o nome do template com "Template Numérico Inválido"
    E tento configurar a questão 1 do tipo "numérica (1-5)" com escala fora de 1 a 5
    E clico em "Criar"
    Então devo ver a mensagem "A escala numérica deve ser de 1 a 5"
    E o template não é criado
