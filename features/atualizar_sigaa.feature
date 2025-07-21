#language: pt
Funcionalidade: Atualizar base de dados com os dados do SIGAA
  Eu como Administrador
  Quero atualizar a base de dados já existente com os dados atuais do sigaa
  A fim de corrigir a base de dados do sistema

  Contexto:
    Dado que eu estou logado como admin
    E que eu estou na página de gerenciamento do CAMAAR
    E que foram importados dados do SIGAA
    Quando eu clicar no botão "Importar dados"


  Cenário: Sucesso na importação (HAPPY)
    E eu selecionar o arquivo "valido2.json" para importar
    Então eu devo estar na página de gerenciamento do CAMAAR
    E eu devo ver "Dados importados com sucesso: alguns dados foram atualizados"


  Cenário: JSON inválido (caminho triste),
    E eu selecionar o arquivo "invalido.json" para importar
    Então eu devo estar na página de gerenciamento do CAMAAR
    E eu devo ver "Falha ao importar dados: dados do arquivo em formato inválido"


  Cenário: Arquivo não é um JSON (caminho triste),
    E eu selecionar o arquivo "invalido.txt" para importar
    Então eu devo estar na página de gerenciamento do CAMAAR
    E eu devo ver "Falha ao importar dados: arquivo com extensão incorreta"