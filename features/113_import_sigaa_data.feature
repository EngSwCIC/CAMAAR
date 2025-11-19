# language: pt
Funcionalidade: Importação de dados do SIGAA (#113)
  Como Administrador
  Quero importar dados de turmas, matérias e participantes do SIGAA (caso não existam na base de dados atual)
  A fim de alimentar a base de dados do sistema

  Contexto:
    Dado que estou autenticado como administrador
    E estou na página "importacao/sigaa" do sistema
    E existem arquivos JSON de turmas, matérias e participantes disponíveis no repositório

  Cenário: Importar novos dados do SIGAA com sucesso
    Dado que existem turmas, matérias e participantes nos arquivos JSON que ainda não existem na base de dados
    Quando eu seleciono os arquivos JSON do SIGAA para importação
    E confirmo a importação dos dados
    Então as turmas do SIGAA que não existiam são cadastradas na base de dados
    E as matérias do SIGAA que não existiam são cadastradas na base de dados
    E os participantes do SIGAA que não existiam são cadastrados na base de dados
    E devo ver a mensagem "Importação concluída com sucesso"

  Cenário: Evitar duplicação de dados já existentes na base
    Dado que algumas turmas, matérias e participantes dos arquivos JSON já existem na base de dados
    Quando eu realizo a importação dos dados do SIGAA
    Então os registros já existentes não são duplicados na base de dados
    E apenas os registros inexistentes são criados
    E devo ver a mensagem "Importação concluída: X novos registros criados, Y registros ignorados por já existirem"

  Cenário: Erro de validação quando o arquivo JSON está inválido
    Dado que o arquivo JSON de turmas está em formato inválido
    Quando eu tento importar os dados do SIGAA
    Então devo ver a mensagem "Não foi possível processar o arquivo JSON de turmas"
    E nenhum dado é importado a partir desse arquivo inválido

  Cenário: Erro quando nenhum arquivo é selecionado
    Dado que não selecionei nenhum arquivo JSON para importação
    Quando eu tento iniciar a importação dos dados do SIGAA
    Então devo ver a mensagem "Selecione ao menos um arquivo JSON para importação"
    E nenhum dado é importado
