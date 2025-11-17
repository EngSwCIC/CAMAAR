# language: pt

Funcionalidade: Criar Template de Formulário
  Como Administrador do sistema
  Eu quero criar templates de formulários com questões personalizadas
  Para que eu possa gerar formulários de avaliação reutilizáveis para avaliar o desempenho das turmas

  Contexto:
    Dado que estou logado como administrador com email "admin@unb.br"
    E estou na página de gerenciamento de templates

  # ========================================
  # CENÁRIOS FELIZES
  # ========================================

  Cenário: Criar template de formulário com sucesso
    Quando eu clico no botão "Novo Template"
    E eu preencho o campo "Nome do Template" com "Avaliação de Desempenho Docente 2025"
    E eu clico em "Adicionar Questão"
    E eu seleciono o tipo de questão "Dissertativa"
    E eu preencho o enunciado da questão com "Como você avalia a didática do professor?"
    E eu clico no botão "Criar"
    Então eu devo ver a mensagem "Template criado com sucesso"
    E eu devo ver "Avaliação de Desempenho Docente 2025" na lista de templates
    E o template deve aparecer como disponível para uso

 # ========================================
  # CENÁRIOS TRISTES
  # ========================================

  Cenário: Tentar criar template sem nome
    Quando eu clico no botão "Novo Template"
    E eu deixo o campo "Nome do Template" vazio
    E eu preencho o campo "Descrição" com "Template sem nome"
    E eu adiciono uma questão dissertativa
    E eu clico no botão "Criar"
    Então eu devo ver a mensagem de erro "Nome do template é obrigatório"
    E nenhum template deve ser criado
    