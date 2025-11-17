# language: pt

Funcionalidade: Atualizar base de dados com os dados do SIGAA
  Como Administrador do sistema
  Eu quero atualizar a base de dados já existente com os dados atuais do SIGAA
  Para que eu possa corrigir a base de dados do sistema

  Contexto:
    Dado que estou logado como administrador com email "admin@unb.br"
    E a base de dados já possui dados importados anteriormente
    E estou na página de gerenciamento

  # ========================================
  # CENÁRIOS FELIZES
  # ========================================

  Cenário: Atualizar base de dados com sucesso
    Dado que o SIGAA está disponível e funcionando normalmente
    E existem novos dados disponíveis no SIGAA
    Quando eu clico no botão "Atualizar dados do SIGAA"
    E eu confirmo a atualização
    Então eu devo ver a mensagem "Base de dados atualizada com sucesso"
    E os dados antigos devem ser atualizados com os dados atuais do SIGAA
    E novos registros devem ser adicionados se existirem
    E devo ver o relatório de atualização mostrando o que foi alterado

  Cenário: Atualizar base de dados sem alterações
    Dado que o SIGAA está disponível e funcionando normalmente
    E não existem alterações nos dados do SIGAA
    Quando eu clico no botão "Atualizar dados do SIGAA"
    E eu confirmo a atualização
    Então eu devo ver a mensagem "Nenhuma alteração encontrada. Base de dados já está atualizada"
    E nenhum dado deve ser modificado

  # ========================================
  # CENÁRIOS TRISTES
  # ========================================

  Cenário: Tentar atualizar quando SIGAA está indisponível
    Dado que o SIGAA está indisponível ou fora do ar
    Quando eu clico no botão "Atualizar dados do SIGAA"
    E eu confirmo a atualização
    Então eu devo ver a mensagem de erro "Erro: não foi possível conectar ao SIGAA. Tente novamente mais tarde"
    E nenhum dado deve ser modificado
    E eu devo permanecer na página de gerenciamento

  Cenário: Tentar atualizar sem confirmação
    Dado que o SIGAA está disponível e funcionando normalmente
    Quando eu clico no botão "Atualizar dados do SIGAA"
    E eu cancelo a confirmação
    Então nenhuma atualização deve ser realizada
    E eu devo permanecer na página de gerenciamento
    E nenhum dado deve ser modificado

  Cenário: Atualização parcial devido a dados inválidos
    Dado que o SIGAA está disponível e funcionando normalmente
    E alguns dados do SIGAA estão em formato inválido
    Quando eu clico no botão "Atualizar dados do SIGAA"
    E eu confirmo a atualização
    Então eu devo ver a mensagem "Atualização parcial concluída. Alguns dados não puderam ser atualizados"
    E os dados válidos devem ser atualizados
    E devo ver um relatório indicando quais dados falharam
    E os dados inválidos não devem ser inseridos na base de dados

