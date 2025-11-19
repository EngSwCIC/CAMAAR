Feature: Importação de dados do SIGAA
    Como Administrador
    Quero importar dados de turmas, matérias e participantes do SIGAA (caso não existam na base de dados atual)
    A fim de alimentar a base de dados do sistema

    Background:
        Given que o administrador está autenticado no sistema
        And que o administrador possui permissão para importar dados do SIGAA
        And que os arquivos seguem o formato esperado pelo sistema

    Scenario: Importar dados válidos de turmas, matérias e participantes
        When o administrador acessa a página de importação de dados do SIGAA
        And seleciona os arquivos válidos presentes no repositório
        And confirma a importação
        Then o sistema deve importar as turmas que ainda não existem na base
        And deve importar as matérias que ainda não existem na base
        And deve importar os participantes que ainda não existem na base
        And deve exibir uma mensagem confirmando a importação com sucesso

    Scenario: Importar dados onde alguns itens já existem na base
        Given que algumas turmas, matérias ou participantes já estão cadastrados no sistema
        When o administrador realiza a importação dos arquivos
        Then o sistema deve ignorar os itens duplicados
        And deve cadastrar apenas os dados novos
        And deve exibir uma mensagem informando que alguns dados já existiam na base

    Scenario: Tentar importar arquivos inválidos
        When o administrador tenta importar arquivos que não seguem o formato esperado
        Then o sistema deve impedir a importação
        And deve exibir uma mensagem informando que o arquivo é inválido

    Scenario: Tentar importar arquivos vazios
        When o administrador seleciona vazios para importação
        Then o sistema deve impedir a importação
        And deve exibir uma mensagem informando que os arquivos não contêm dados

    Scenario: Erro inesperado durante a importação
        When o administrador confirma a importação dos arquivos
        And ocorre um erro interno inesperado
        Then o sistema deve exibir uma mensagem genérica de erro
        And instruir o administrador a tentar novamente mais tarde
