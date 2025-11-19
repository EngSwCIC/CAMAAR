# language: pt
@testes
@admim
@importa_sigaa


Funcionalidade: Importar dados do SIGAA #98
    Eu como Administrador
    Quero importar dados de turmas, matérias e participantes do SIGAA (caso não existam na base de dados atual)
    A fim de alimentar a base de dados do sistema.

    Contexto:
        Dado que um 'administrador' está logado
        E está na tela 'Gerenciamento'
        E o banco de dados está 'vazio'

    @98.1
    Cenário: 98.1 - Quando um administrador tenta importar novos dados do SIGAA, eles devem ser salvos na base de dados
        Quando a conexão com o SIGAA está 'funcionando'
        E tenta importar dados do SIGAA
        Entao deve mostrar dados do SIGAA na tela de resultados
        E os dados do SIGAA devem estar salvos no banco de dados

    @98.2
    Cenário: 98.2 - Quando um administrador tenta importar novos dados do SIGAA, mas a conexão com o SIGAA estiver falhando, então deve mostrar mensagem de erro de conexão com o SIGAA, não deve mostrar nenhuma informação na tela e o banco de dados deve se manter como estava
        Quando a conexão com o SIGAA está 'falhando'
        E tenta importar dados do SIGAA
        Entao não deve mostrar dados do SIGAA na tela de resultados
        E o banco de dados deve continuar vazio
        E deve mostrar mensagem de erro de 'conexão_com_sigaa'

    @98.3
    Cenário: 98.3 - Quando um administrador tenta importar novos dados do SIGAA, mas a conexão com o Banco de Dados estiver falhando, então deve mostrar mensagem de erro de conexão com o banco de dados, não deve mostrar nenhuma informação na tela e o banco de dados deve se manter como estava
        Quando a conexão com o SIGAA está 'funcionando'
        E tenta importar dados do SIGAA
        E o banco de dados está com problema
        Entao não deve mostrar dados do SIGAA na tela de resultados
        E deve mostrar mensagem de erro de 'banco_de_dados'
        E o banco de dados deve continuar vazio

    @98.4
    Cenário: 98.4 - Quando um administrador tenta importar novos dados do SIGAA, mas os dados fornecidos forem inválidos, então deve mostrar mensagem de erro de dados inválidos enviados pelo SIGAA, não deve mostrar nenhuma informação na tela e o banco de dados deve se manter como estava
        Quando a conexão com o SIGAA está 'inválida'
        E tenta importar dados do SIGAA
        E o banco de dados está com problema
        Entao não deve mostrar dados do SIGAA na tela de resultados
        E deve mostrar mensagem de erro de 'sigaa_invalido'
        E o banco de dados deve continuar vazio