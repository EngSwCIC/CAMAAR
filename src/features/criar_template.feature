# language: pt
# features/criar_template.feature

Funcionalidade: Criação de Template de Formulário
  Eu como Administrador
  Quero criar um template de formulário contendo as questões do formulário
  A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

Contexto:
  Dado que eu sou um "admin" logado no sistema

@happy_path
Cenário: Admin cria um template com sucesso
  Dado que eu estou na página "templates/new"
  Quando eu preencho "Nome do Template" com "Avaliação Semestral 2025.1"
  E eu adiciono uma pergunta "O professor foi didático?" do tipo "numérica (1-5)"
  E eu adiciono uma pergunta "A infraestrutura foi adequada?" do tipo "múltipla escolha" com opções "Sim, Não, Parcialmente"
  E eu adiciono uma pergunta "Comentários gerais" do tipo "texto"
  E eu clico no botão "Salvar Template"
  Então eu devo ser redirecionado para a página "templates"
  E eu devo ver a mensagem "Template 'Avaliação Semestral 2025.1' criado com sucesso"

@sad_path
Cenário: Admin tenta criar um template sem nome
  Dado que eu estou na página "templates/new"
  Quando eu adiciono uma pergunta "O professor foi didático?" do tipo "numérica (1-5)"
  E eu clico no botão "Salvar Template"
  Então eu devo permanecer na página "templates/new"
  E eu devo ver a mensagem de erro "Nome do Template não pode ficar em branco"

@sad_path
Cenário: Admin tenta criar um template sem perguntas
  Dado que eu estou na página "templates/new"
  Quando eu preencho "Nome do Template" com "Template Vazio"
  E eu clico no botão "Salvar Template"
  Então eu devo permanecer na página "templates/new"
  E eu devo ver a mensagem de erro "Template deve ter pelo menos uma pergunta"

@sad_path
Cenário: Admin tenta criar um template com uma pergunta sem texto
  Dado que eu estou na página "templates/new"
  Quando eu preencho "Nome do Template" com "Template Teste"
  E eu adiciono uma pergunta "" do tipo "texto"
  E eu clico no botão "Salvar Template"
  Então eu devo permanecer na página "templates/new"
  E eu devo ver a mensagem de erro "O enunciado da pergunta não pode ficar vazio"

@sad_path
Cenário: Admin tenta criar um template com alternativas vazias
  Dado que eu estou na página "templates/new"
  Quando eu preencho "Nome do Template" com "Template Teste"
  E eu adiciono uma pergunta "Qual sua cor favorita?" do tipo "múltipla escolha" com opções "Azul, , Vermelho"
  E eu clico no botão "Salvar Template"
  Então eu devo permanecer na página "templates/new"
  E eu devo ver a mensagem de erro "Todas as alternativas devem ser preenchidas"