# language: pt

Funcionalidade: Visualização dos templates criados
  Como um Administrador
  Eu quero visualizar os templates criados
  De modo que poder editar e/ou deletar um template que eu criei

  Contexto:
    Dado que estou logado como administrador com email "admin@unb.br"
    E estou na página de gerenciamento de templates

  # CENÁRIOS FELIZES

  Cenário: Visualizar lista de templates com sucesso
    Dado que existem templates criados no sistema:
      | nome | questoes | data_criacao |
      | Avaliação Docente | 5 | 2025-11-10 |
      | Avaliação de Infraestrutura | 3 | 2025-11-12 |
      | Feedback da Turma | 4 | 2025-11-15 |
    Quando eu acesso a página de gerenciamento de templates
    Então devo ver a lista de todos os templates
    E cada template deve mostrar seu nome
    E cada template deve mostrar a quantidade de questões
    E cada template deve mostrar sua data de criação
    E cada template deve ter opções de "Editar" e "Deletar"

  Cenário: Visualizar detalhes de um template
    Dado que existe um template com nome "Avaliação de Infraestrutura" e 3 questões
    Quando eu clico em "Visualizar" no template "Avaliação de Infraestrutura"
    Então devo ver os detalhes completos do template
    E devo ver todas as questões do template
    E devo ver o tipo de cada questão (Dissertativa, Múltipla Escolha, etc)
    E devo ver a data de criação do template

  Cenário: Pesquisar templates por nome
    Dado que existem vários templates no sistema
    Quando eu preencho o campo de busca com "Avaliação"
    E eu clico em "Pesquisar"
    Então devo ver apenas os templates que contenham "Avaliação" no nome
    E os templates que não correspondem devem desaparecer

  # CENÁRIOS TRISTES

  Cenário: Visualizar templates quando não há nenhum criado
    Dado que não existem templates criados no sistema
    Quando eu acesso a página de gerenciamento de templates
    Então devo ver a mensagem "Nenhum template encontrado"
    E devo ver a opção "Criar Novo Template"
    E a lista de templates deve estar vazia

  Cenário: Tentar visualizar template deletado
    Dado que existem templates no sistema
    E um template foi deletado
    Quando eu tento acessar o template deletado
    Então devo ver a mensagem de erro "Template não encontrado"
    E devo ser redirecionado para a página de gerenciamento de templates
