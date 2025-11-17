# language: pt

Funcionalidade: Importar Dados do SIGAA
  Como Administrador do sistema
  Eu quero importar dados de turmas, matérias e participantes do SIGAA
  Para que eu possa alimentar a base de dados do sistema

  Contexto:
    Dado que estou logado como administrador com email "admin@unb.br"
    E estou na página de gerenciamento

     # CENÁRIOS FELIZES

  Cenário: Importar turmas com sucesso
    Quando eu seleciono clico no botão "Importar dados"
    E eu seleciono o arquivo JSON "turmas.json"
    E o arquivo contém 1 turma válidas
    E nenhuma turma já existe na base de dados
    E eu clico em "Importar"
    Então eu devo ver a mensagem "1 turmas importadas com sucesso"
    E a turma deve estar cadastrada no sistema
    E devo ver o relatório de importação


  # CENÁRIOS TRISTES

  Cenário: Tentar importar arquivo JSON inválido
    Quando eu seleciono um arquivo "dados_invalidos.json"
    E o arquivo não possui formato JSON válido
    E eu clico em "Importar"
    Então eu devo ver a mensagem de erro "Arquivo JSON inválido"
    E devo ver "Verifique a sintaxe do arquivo"
    E nenhum dado deve ser importado