# language: pt
Funcionalidade: Atualizar base de dados com os dados do SIGAA

  Eu como Administrador do sistema CAMAAR
  Quero inserir os dados atuais do SIGAA na base de dados do CAMAAR
  A fim de atualizar e corrigir a base de dados do sistema.

  # FELIZ
  Cenário: Atualizar os dados com sucesso
    Dado que estou logado no sistema como administrador
    E acesso a pagina de importação de dados para atualização/correção
    Quando seleciono o novo arquivo de dados atuais do SIGAA
    E seleciono a opção de confirmação de atualização
    Então recebo um mensagem de cofirmação
    E a base de dados é atualizada com sucesso

  # TRISTE
  Cenário: Atualizar os dados com dados inválidos
    Dado que estou logado no sistema como administrador
    E acesso a pagina de importação de dados para atualização/correção
    Quando seleciono o novo arquivo de dados atuais do SIGAA
    E seleciono a opção de confirmação de atualização
    E recebo uma mensagem de erro informando que o formato do arquivo é inválido
    Então recebo um mensagem para selecionar um arquivo valido e tentar novamente

 # TRISTE
  Cenário: Erro ao corrigir a base os dados
    Dado que estou logado no sistema como administrador
    E o sistema está com problema na base
    E acesso a pagina de importação de dados para atualização/correção
    Quando seleciono o novo arquivo de dados corrompido
    E seleciono a opção de confirmação
    Então recebo uma mensagem de erro informando que o arquivo está corropido
    E recebo uma mensagem para selecionar um arquivo valido e tentar novamente
