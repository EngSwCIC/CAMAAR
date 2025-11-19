Feature: Visualização de templates criados
    Como Administrador
    Quero visualizar os templates criados
    A fim de poder editar e/ou deletar um template que eu criei

    # Cenários que exigem autenticação do administrador
    Background:
        Given que existe um administrador autenticado

    Scenario: Visualizar lista de templates com sucesso
        Given que existem templates cadastrados no sistema
        When o administrador acessa a página de templates
        Then o sistema deve exibir a lista de templates existentes
        And cada template deve apresentar opções para edição e exclusão

    Scenario: Visualizar lista de templates vazia
        Given que não existem templates cadastrados no sistema
        When o administrador acessa a página de templates
        Then o sistema deve informar que não há templates disponíveis

    Scenario: Acessar detalhes de um template
        Given que existe ao menos um template cadastrado
        When o administrador seleciona um template da lista
        Then o sistema deve exibir os detalhes do template
        And deve disponibilizar opções para editar ou deletar o template

    # Cenário sem Background, pois não envolve administrador autenticado
    Scenario: Tentar acessar lista de templates sem estar autenticado
        Given que o usuário não está autenticado como administrador
        When ele tenta acessar a página de templates
        Then o sistema deve negar o acesso
        And exibir uma mensagem indicando falta de permissão