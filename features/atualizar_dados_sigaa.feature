# encoding : UTF-8
# language: pt

Funcionalidade: Atualizar base de dados do sistema com dados do SIGAA
                Eu, como Administrador
                Quero atualizar os dados de turmas, matérias e participantes do sistema com os dados atuais do SIGAA
                A fim de corrigir a base de dados do sistema

Contexto:
    Dado que estou na página de gerenciamento 
    E que os dados do SIGAA foram importados com sucesso

Cenário: Atualização de dados do SIGAA (happy path)
    Dado que os dados do SIGAA foram atualizados com sucesso
    Então as turmas, matérias e participantes do SIGAA estão atualizados no sistema com os dados atuais do SIGAA

Cenário: Atualização de dados do SIGAA com falha (sad path)
    Dado que eu tentei atualizar os dados do SIGAA mas ocorreu um erro
    Então uma mensagem de erro é exibida informando que a atualização falhou

Cenário: Atualização de dados do SIGAA com dados já atualizados (sad path)
    Dado que os dados do SIGAA já estão atualizados na base de dados do sistema
    Então uma mensagem é exibida informando que os dados já estão atualizados e não serão atualizados novamente

Cenário: Atualização de dados do SIGAA com dados parcialmente atualizados (sad path)
    Dado que alguns dados do SIGAA já estão atualizados na base de dados do sistema
    Então uma mensagem é exibida informando que alguns dados já estão atualizados e não serão atualizados novamente, mas os dados restantes serão atualizados com sucesso
