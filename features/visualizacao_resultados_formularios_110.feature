# language: pt

Funcionalidade: Visualização de resultados dos formulários
  Como um Administrador
  Eu quero visualizar os formulários criados
  De modo que poder gerar um relatório a partir das respostas

  Contexto:
    Dado que estou logado como administrador com email "admin@unb.br"
    E existe um formulário "Avaliação Semestral" para a turma "CIC0097"
    E o formulário possui 10 respostas de alunos
    E estou na página de gerenciamento de resultados

  # CENÁRIOS FELIZES

  Cenário: Visualizar lista de formulários com respostas
    Quando eu acesso a página de gerenciamento de resultados
    Então devo ver todos os formulários criados
    E cada formulário deve mostrar a turma associada
    E cada formulário deve mostrar o número de respostas
    E cada formulário deve mostrar a data de criação
    E devo ver a opção "Ver Respostas" para cada formulário

  Cenário: Visualizar detalhes das respostas de um formulário
    Dado que eu clico em "Ver Respostas" no formulário "Avaliação Semestral"
    Quando a página de resultados carrega
    Então devo ver todas as 10 respostas do formulário
    E devo ver o nome do aluno que respondeu
    E devo ver a data de resposta
    E devo ver as respostas de cada questão
    E devo ver estatísticas das respostas (média, moda, etc)

  Cenário: Gerar relatório em CSV com sucesso
    Dado que estou visualizando as respostas do formulário "Avaliação Semestral"
    Quando eu clico no botão "Gerar Relatório"
    E eu seleciono o formato "CSV"
    E eu clico em "Download"
    Então o download do arquivo "avaliacao_semestral_cic0097.csv" deve iniciar
    E o arquivo deve conter os cabeçalhos das colunas
    E o arquivo deve conter todas as 10 respostas
    E o arquivo deve estar em formato CSV válido

  Cenário: Filtrar respostas por data
    Dado que estou na página de resultados
    Quando eu seleciono o filtro de data "De 10/11/2025 até 17/11/2025"
    E eu clico em "Aplicar Filtro"
    Então devo ver apenas as respostas dentro do período selecionado
    E o número de respostas deve ser atualizado

  # CENÁRIOS TRISTES

  Cenário: Visualizar formulário sem respostas
    Dado que existe um formulário "Avaliação Nova" sem respostas
    Quando eu clico em "Ver Respostas" deste formulário
    Então devo ver a mensagem "Este formulário ainda não possui respostas"
    E o arquivo CSV pode ser gerado mesmo sem dados

  Cenário: Tentar acessar relatório de formulário inexistente
    Quando eu tento acessar o relatório de um formulário que não existe
    Então devo ver a mensagem de erro "Formulário não encontrado"
    E devo ser redirecionado para a página de gerenciamento de resultados
