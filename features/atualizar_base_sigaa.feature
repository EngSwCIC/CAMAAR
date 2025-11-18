# language: pt

@issue-108
Funcionalidade: Atualização da base de dados com informações do SIGAA
  Como administrador
  Quero atualizar a base de dados com os dados atuais do SIGAA
  Para corrigir e manter atualizada a base de dados do sistema

  Contexto:
    Dado que existe um administrador autenticado no sistema
    E o administrador está na página de atualização da base de dados

  Cenário: Atualização bem-sucedida
    Quando o administrador aciona o comando de sincronização com o SIGAA
    Então o sistema deve buscar os dados mais recentes no SIGAA
    E deve substituir os dados desatualizados na base interna
    E deve exibir a mensagem "Base de dados atualizada com sucesso"

  Cenário: Falha na comunicação com o SIGAA
    Quando o administrador tenta sincronizar
    E o SIGAA está indisponível
    Então o sistema deve exibir a mensagem "Falha ao comunicar com o SIGAA"
    E não deve alterar os dados existentes na base

  Cenário: Dados inconsistentes retornados pelo SIGAA
    Dado que o SIGAA retorna informações incompletas ou com erro
    Quando a sincronização é executada
    Então o sistema deve abortar a atualização
    E deve exibir a mensagem "Dados inconsistentes fornecidos pelo SIGAA"

  Cenário: Administrador tenta atualizar sem permissão
    Dado que um usuário comum tenta acessar a área de atualização
    Então o sistema deve bloquear o acesso
    E deve exibir a mensagem "Acesso restrito aos administradores"