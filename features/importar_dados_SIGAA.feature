# language: pt

#Issue-19

Funcionalidade: Importar dados do SIGAA
  Como administrador
  Quero importar dados do SIGAA
  A fim de cadastrar informações acadêmicas no sistema

  Cenário: Caminho feliz
    Dado que o arquivo JSON é válido
    E existem dados disponíveis para importação
    Quando o administrador solicitar a importação
    Então os dados devem ser importados com sucesso
    E armazenados na base de dados

  Cenário: Caminho triste
    Dado que o JSON está inválido, ausente ou mal formatado
    Quando o administrador solicitar a importação
    Então o sistema deve exibir uma mensagem de erro
    E nenhum dado deve ser salvo
