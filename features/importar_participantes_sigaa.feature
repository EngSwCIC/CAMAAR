Feature: Importação de participantes de turmas do SIGAA
    Como Administrador
    Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuários novos para o sistema
    A fim de que eles acessem o sistema CAMAAR

    Background:
        Given que o administrador está autenticado no sistema
        And que o administrador possui permissão para importar dados do SIGAA
        And que o sistema possui integração com os dados exportados do SIGAA

    Scenario: Importar arquivo válido com novos participantes
        When o administrador acessa a página de importação de usuários
        And seleciona um arquivo válido exportado do SIGAA
        And confirma a importação
        Then o sistema deve cadastrar os novos participantes
        And deve associá-los corretamente às suas respectivas turmas
        And deve exibir uma mensagem confirmando a importação com sucesso

    Scenario: Importar arquivo contendo usuários já cadastrados
        Given que alguns usuários presentes no arquivo já existem no sistema
        When o administrador realiza a importação do arquivo
        Then o sistema deve ignorar os usuários duplicados
        And deve cadastrar somente os usuários novos
        And deve exibir uma mensagem informando que alguns usuários já estavam cadastrados

    Scenario: Tentar importar arquivo com formato inválido
        When o administrador tenta importar um arquivo que não segue o formato esperado do SIGAA
        Then o sistema deve impedir a importação
        And deve exibir uma mensagem informando que o arquivo é inválido

    Scenario: Tentar importar arquivo vazio
        When o administrador seleciona um arquivo vazio para importação
        Then o sistema deve impedir a importação
        And deve exibir uma mensagem informando que o arquivo não contém dados

    Scenario: Erro inesperado durante a importação
        When o administrador confirma a importação de um arquivo
        And ocorre um erro interno inesperado
        Then o sistema deve exibir uma mensagem genérica de erro
        And instruir o administrador a tentar novamente mais tarde
