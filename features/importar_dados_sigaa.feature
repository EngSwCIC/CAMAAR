# encoding : UTF-8
# language: pt

Funcionalidade: Importar dados do SIGAA
                Eu, como Administrador
                Quero importar dados de turmas, matérias e participantes do SIGAA (caso não existam na base de dados atual
                A fim de alimentar a base de dados do sistema
                P.S. utilizar os JSONs presentes no repositório

Contexto:
    Dado que estou na página de gerenciamento
    E que os dados do SIGAA estão disponíveis para importação

Cenário: Importação de dados do SIGAA (happy path)
    Dado que os dados do SIGAA foram importados com sucesso
    Então as turmas, matérias e participantes do SIGAA estão presentes no sistema

Cenário: Importação de dados do SIGAA com falha (sad path)
    Dado que eu tentei importar os dados do SIGAA mas ocorreu um erro
    Então uma mensagem de erro é exibida informando que a importação falhou

Cenário: Importação de dados do SIGAA com dados já existentes (sad path)
    Dado que os dados do SIGAA já existem na base de dados do sistema
    Então uma mensagem é exibida informando que os dados já foram importados e não serão importados novamente

Cenário: Importação de dados do SIGAA com dados parcialmente existentes (sad path)
    Dado que alguns dados do SIGAA já existem na base de dados do sistema
    Então uma mensagem é exibida informando que alguns dados já foram importados e não serão importados novamente, mas os dados restantes serão importados com sucesso

