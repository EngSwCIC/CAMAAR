# language: pt

Funcionalidade: Atualização da base de dados com dados do SIGAA

  Como administrador
  Quero atualizar a base de dados já existente com os dados atuais do SIGAA
  Para corrigir e manter atualizada a base do sistema

  Cenário: Atualizar manualmente o sistema com a base de dados do sistema SIGAA
    Dado que estou logado como administrador
    E estou na página de gerenciamento da base de dados
    Quando clico na opção "Atualizar com dados do SIGAA"
    Então o sistema deve importar os dados mais recentes do SIGAA
    E deve atualizar os registros existentes sem duplicar ou sobrescrever incorretamente
    E devo ver uma mensagem de confirmação com o status da atualização

  Cenário: Dados incompatíveis ou inválidos detectados
    Dado que estou logado como administrador
    E estou na página de gerenciamento da base de dados
    Quando clico na opção "Atualizar com dados do SIGAA"
    E são detectados dados com formato inválido ou incompatível
    Então esses dados são ignorados
    E o sistema exibe uma mensagem de erro e mantém a base no estado anterior à atualização
