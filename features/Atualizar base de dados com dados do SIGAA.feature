Funcionalidade: Atualizar base de dados com dados do SIGAA
  Como administrador
  Quero importar os dados do SIGAA por meio de um botão
  Para  manter a base de usuários sincronizada com as turmas e dados atualizados

  @feliz
  Cenário: Importar dados atualizando e mantendo os existentes
    Dado que estou logado como administrador
    Quando clico no botão "Importar dados"
    E já existem usuários com os mesmos e-mails no sistema
    Então os dados desses usuários são atualizados com base no JSON
    E os novos usuários do JSON são adicionados

  @feliz
  Cenário: Importação sem alterações (JSON idêntico à base)
    Dado que a base de dados atual já contém os mesmos usuários com os mesmos dados
    Quando clico no botão "Importar dados"
    Então nenhum dado é alterado ou inserido

  @triste
  Cenário: JSON com estrutura inválida ou corrompida
    Dado que há um erro no arquivo JSON de origem (ex: chave faltando, formatação incorreta)
    Quando clico no botão "Importar dados"
    Então vejo a mensagem "Erro ao importar dados- verifique a estruturado JSON"
    E nenhum dado é inserido ou alterado no sistema