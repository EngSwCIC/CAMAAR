# language: pt
Funcionalidade: Cadastrar usuários do sistema

  Eu como Adminstrador do sistema
  Quero cadastrar os usuarios participantes de turmas no SIGAA no CAMAAR fazendo importação de dados
  Para que possam definir suas senhas de autenticação e seja permitido o acesso dos mesmos ao sistema CAMAAR

  # FELIZ
  Cenário: Importar dados de novos usuários com sucesso
    Dado que estou logado no sistema como Administrador
    E tenho um arquivo de dados de novos usuários obtidos do SIGAA
    Quando acesso a página de importação de dados
    E seleciono o arquivo de dados de novos usuários
    E inicio a importação
    Então os dados são importados com sucesso
    E os novos usuários são cadastrados no sistema CAMAAR
    E recebo uma confirmação de que a importação foi concluída com sucesso

    # TRISTE
  Cenário: Importação falha devido a dados inválidos
    Dado que estou logado no sistema como Administrador
    E tenho um arquivo de dados de novos usuários do SIGAA
    Quando acesso a página de importação de dados
    E seleciono o arquivo de dados de novos usuários
    E inicio a importação
    Então recebo uma mensagem de erro indicando que o arquivo contém dados inválidos
    E a importação é cancelada
    E nenhum usuário novo é cadastrado no sistema CAMAAR

     # TRISTE
  Cenário: Importação falha devido a problemas técnicos
    Dado que estou logado no sistema como Administrador
    E tenho um arquivo de dados de novos usuários do SIGAA
    Quando acesso a página de importação de dados
    E seleciono o arquivo de dados de novos usuários
    E inicio a importação
    Então ocorre um erro técnico durante a importação
    E recebo uma mensagem de erro informando sobre o problema
    E nenhum usuário novo é cadastrado no sistema CAMAAR

