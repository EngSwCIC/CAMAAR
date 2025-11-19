# language: pt
@testes
@admim
@importa_sigaa
@atualiza_sigaa


Funcionalidade: Atualizar base de dados com SIGAA #108
    Eu como Administrador
    Quero atualizar a base de dados já existente com os dados atuais do sigaa
    A fim de corrigir a base de dados do sistema.

    Contexto:
        Dado que um 'administrador' está logado
        E está na tela 'Gerenciamento'
        E o banco de dados está 'com dados'

    @108.1
    Cenário: 108.1 - Quando um administrador tenta atualizar a base de dados com o SIGAA, os dados devem ser corrigidos na base de dados
        Quando a conexão com o SIGAA está 'funcionando'
        E tenta atualizar dados do SIGAA
        Entao deve mostrar dados atualizados na tela de resultados
        E os dados do SIGAA devem estar atualizados no banco de dados

    @108.2
    Cenário: 108.2 - Quando um administrador tenta atualizar a base de dados com o SIGAA, mas a conexão com o SIGAA estiver falhando, então deve mostrar mensagem de erro de conexão com o SIGAA, não deve mostrar nenhuma informação na tela e o banco de dados deve se manter como estava
        Quando a conexão com o SIGAA está 'falhando'
        E tenta atualizar dados do SIGAA
        Entao não deve mostrar dados atualizados na tela de resultados
        E o banco de dados deve continuar como estava
        E deve mostrar mensagem de erro de 'conexão_com_sigaa'

    @108.3
    Cenário: 108.3 - Quando um administrador tenta atualizar a base de dados com o SIGAA, mas a conexão com o Banco de Dados estiver falhando, então deve mostrar mensagem de erro de conexão com o banco de dados, não deve mostrar nenhuma informação na tela e o banco de dados deve se manter como estava
        Quando a conexão com o SIGAA está 'funcionando'
        E tenta atualizar dados do SIGAA
        E o banco de dados está com problema
        Entao não deve mostrar dados atualizados na tela de resultados
        E deve mostrar mensagem de erro de 'banco_de_dados'
        E o banco de dados deve continuar como estava

    @108.4
    Cenário: 108.4 - Quando um administrador tenta atualizar a base de dados com o SIGAA, mas os dados fornecidos forem inválidos, então deve mostrar mensagem de erro de dados inválidos enviados pelo SIGAA, não deve mostrar nenhuma informação na tela e o banco de dados deve se manter como estava
        Quando a conexão com o SIGAA está 'inválida'
        E tenta atualizar dados do SIGAA
        E o banco de dados está com problema
        Entao não deve mostrar dados atualizados na tela de resultados
        E deve mostrar mensagem de erro de 'sigaa_invalido'
        E o banco de dados deve continuar como estava
