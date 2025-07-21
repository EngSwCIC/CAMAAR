#language: pt

Funcionalidade: Importar dados do SIGAA
  Eu como Administrador
  Quero importar dados de turmas, matérias e participantes
  do SIGAA (caso não existam na base de dados atual)
  A fim de alimentar a base de dados do sistema.

  Contexto:
    Dado que eu estou logado como admin
    E que eu estou na página de gerenciamento do CAMAAR

  Cenário: Upload de dados bem-sucedido (HAPPY)
    Quando eu clicar no botão "Importar dados"
    E eu selecionar o arquivo "valido.json" para importar
    Então eu devo estar na página de gerenciamento do CAMAAR
    E eu devo ver "Dados importados com sucesso"

  Cenário: Tentativa de upload de arquivo de tipo inválido (SAD)
    Quando eu clicar no botão "Importar dados"
    E eu selecionar o arquivo "invalido.txt" para importar
    Então eu devo estar na página de gerenciamento do CAMAAR
    E eu devo ver "Falha ao importar dados: arquivo com extensão incorreta"

  Cenário: Tentativa de upload de arquivo com dados inválidos (SAD)
    Quando eu clicar no botão "Importar dados"
    E eu selecionar o arquivo "invalido.json" para importar
    Então eu devo estar na página de gerenciamento do CAMAAR
    E eu devo ver "Falha ao importar dados: dados do arquivo em formato inválido"