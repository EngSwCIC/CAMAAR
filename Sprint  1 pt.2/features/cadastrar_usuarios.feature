# language: pt
Funcionalidade: Cadastrar usuários do sistema
  Como Administrador
  Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuários novos
  A fim de que eles possam acessar o sistema CAMAAR

  Contexto:
    Dado que o administrador está autenticado no sistema
    E acessa o módulo de "Gerenciamento"

  Cenário: Cadastro bem-sucedido de usuários a partir de importação do SIGAA (Caminho Feliz)
    Dado que o administrador possui um arquivo JSON válido com dados de participantes do SIGAA
    Quando o administrador aciona a opção "Importar Dados"
    E seleciona o arquivo JSON com os dados dos participantes
    Então o sistema deve cadastrar os usuários no banco de dados
    E exibir a mensagem "Usuários cadastrados com sucesso"
    E os usuários devem conseguir acessar o sistema CAMAAR

  Cenário: Falha ao tentar cadastrar usuários com arquivo inválido (Caminho Triste)
    Dado que o administrador possui um arquivo com formato inválido
    Quando o administrador aciona a opção "Importar Dados"
    E seleciona o arquivo inválido
    Então o sistema deve rejeitar a importação
    E exibir a mensagem de erro "Formato de arquivo inválido. Utilize um arquivo JSON válido"
