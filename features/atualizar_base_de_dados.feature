Feature: Atualização da base de dados com informações do SIGAA
    Como Administrador
    Quero atualizar a base de dados já existente com os dados atuais do SIGAA
    A fim de corrigir a base de dados do sistema

    Background:
        Given que existe um administrador autenticado

    Scenario: Atualizar base de dados com sucesso
        Given que o sistema está conectado à integração com o SIGAA
        When o administrador acessa a funcionalidade de atualização de dados
        And solicita a atualização da base
        Then o sistema deve buscar os dados atuais no SIGAA
        And atualizar a base de dados local com as informações recebidas
        And exibir uma mensagem de sucesso informando que a atualização foi concluída

    Scenario: Falha na comunicação com o SIGAA
        Given que o sistema não consegue acessar o SIGAA
        When o administrador solicita a atualização da base
        Then o sistema deve informar que não foi possível se conectar ao SIGAA
        And exibir uma mensagem orientando a tentar novamente mais tarde

    Scenario: Dados recebidos estão incompletos ou inconsistentes
        Given que o SIGAA retorna dados inconsistentes ou incompletos
        When o administrador solicita a atualização da base
        Then o sistema deve impedir a atualização
        And exibir uma mensagem indicando o problema nos dados recebidos