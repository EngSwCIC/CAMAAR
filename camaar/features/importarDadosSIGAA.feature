# language: pt

Funcionalidade: Importação de dados do SIGAA

  Eu como Administrador do CAMAAR
  Quero importar dados de turmas, matérias e participantes do SIGAA por meio de um arquivo JSON
  A fim de atualizar ou popular a base de dados do sistema.

  # FELIZ
  Cenário: Importar dados com sucesso a partir de um arquivo JSON
    Dado que estou logado no sistema CAMAAR como Administrador
    E possuo um arquivo JSON válido(formatação) com dados de turmas, matérias e participantes do SIGAA
    Quando acesso a página de importação de dados do SIGAA
    E seleciono o arquivo JSON para importação
    E confirmo a importação
    Então os dados são importados com sucesso para o sistema CAMAAR
    E a base de dados do sistema é atualizada com as informações do arquivo JSON
    E recebo uma mensagem de confirmação de que a importação foi concluída com sucesso

  # TRISTE
  Cenário: Falha na importação devido a formato inválido do arquivo JSON
    Dado que estou logado no sistema CAMAAR como Administrador
    E possuo um arquivo JSON inválido para importação
    Quando acesso a página de importação de dados do SIGAA
    E seleciono o arquivo JSON para importação
    E tento confirmar a importação
    Então recebo uma mensagem de erro informando que o formato do arquivo JSON é inválido
    E a importação não é realizada
    E a base de dados do sistema permanece inalterada

   # TRISTE
  Cenário: Falha na importação devido a seleção de arquivo inválido
    Dado que estou logado no sistema CAMAAR como Administrador
    E tenho um arquivo inválido para importação (por exemplo, um arquivo de texto ou um arquivo CSV)
    Quando acesso a página de importação de dados do SIGAA
    E seleciono o arquivo inválido para importação
    E tento confirmar a importação
    Então recebo uma mensagem de erro informando que o arquivo selecionado não é um arquivo JSON válido
    E a importação não é realizada
    E a base de dados do sistema permanece inalterada