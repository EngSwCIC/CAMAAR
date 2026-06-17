# language: pt

Funcionalidade: Atualização da base de dados com o SIGAA

  Como administrador
  Quero atualizar a base de dados já existente com os dados atuais do SIGAA
  A fim de corrigir a base de dados do sistema

  Contexto:
    Dado que estou logado como administrador
    E o sistema possui integração ativa com o SIGAA

  Cenário: Atualização da base de dados com sucesso
    Quando solicito a atualização dos dados a partir do SIGAA
    E o SIGAA retorna dados válidos
    Então a base de dados do sistema deve ser atualizada com os novos dados
    E devo ver uma mensagem de sucesso na atualização

  Cenário: SIGAA retorna dados inconsistentes
    Quando solicito a atualização dos dados a partir do SIGAA
    E o SIGAA retorna dados inconsistentes
    Então a atualização não deve ser concluída
    E devo ver uma mensagem de erro informando inconsistência de dados

  Cenário: Falha de conexão com o SIGAA
    Quando solicito a atualização dos dados a partir do SIGAA
    E não há conexão com o SIGAA
    Então a atualização não deve ser realizada
    E devo ver uma mensagem informando falha de comunicação

  Cenário: Usuário sem permissão tenta atualizar base
    Dado que estou logado como usuário comum
    Quando tento solicitar a atualização da base de dados
    Então devo ser impedido de realizar a ação
    E devo ver uma mensagem de acesso negado

  Cenário: Atualização parcial dos dados
    Quando solicito a atualização dos dados a partir do SIGAA
    E o SIGAA retorna parcialmente os dados com sucesso
    Então o sistema deve atualizar apenas os dados válidos
    E deve registrar os dados que falharam na atualização

  Cenário: Evitar atualização duplicada da base de dados
    Dado que já existe uma atualização em andamento
    Quando solicito uma nova atualização dos dados a partir do SIGAA
    Então devo ser impedido de iniciar outra atualização
    E devo ver uma mensagem informando que já existe um processo em execução

  Cenário: Reprocessar atualização após falha
    Dado que uma atualização anterior falhou
    Quando solicito uma nova tentativa de atualização
    Então o sistema deve reprocessar os dados do SIGAA
    E a base de dados deve ser atualizada com sucesso caso os dados sejam válidos

  Cenário: Atualização sem dados retornados pelo SIGAA
    Quando solicito a atualização dos dados a partir do SIGAA
    E o SIGAA não retorna nenhum dado
    Então a atualização não deve ser realizada
    E devo ver uma mensagem informando ausência de dados

  Cenário: Registro de auditoria da atualização
    Quando solicito a atualização dos dados a partir do SIGAA
    E a atualização é executada
    Então o sistema deve registrar um log da atualização
    E o log deve conter data, usuário responsável e resultado da operação