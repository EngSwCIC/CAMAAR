Feature: Gerenciamento de turmas por departamento
    Como Administrador
    Quero gerenciar somente as turmas do departamento ao qual eu pertenço
    A fim de avaliar o desempenho das turmas no semestre atual

    Background:
        Given que existe um administrador autenticado
        And que o administrador pertence a um departamento específico
        And que existem turmas cadastradas em vários departamentos

    Scenario: Visualizar apenas as turmas do próprio departamento
        When o administrador acessa a página de gerenciamento de turmas
        Then o sistema deve exibir somente as turmas pertencentes ao departamento do administrador
        And não deve exibir turmas de outros departamentos

    Scenario: Tentar acessar turma de outro departamento
        Given que existe uma turma de outro departamento
        When o administrador tenta acessar os detalhes dessa turma
        Then o sistema deve negar o acesso
        And deve exibir uma mensagem informando permissão insuficiente

    Scenario: Gerenciar turmas do próprio departamento
        Given que existem turmas vinculadas ao departamento do administrador
        When o administrador seleciona uma turma da lista
        Then o sistema deve permitir visualizar dados da turma
        And deve permitir ações como gerar relatórios, visualizar formulários ou acompanhar desempenho

    Scenario: Não há turmas no departamento do administrador
        Given que o departamento do administrador não possui turmas cadastradas para o semestre atual
        When o administrador acessa a página de gerenciamento de turmas
        Then o sistema deve informar que não existem turmas disponíveis para o departamento

    Scenario: Usuário não autenticado tenta acessar gerenciamento de turmas
        Given que o usuário não está autenticado
        When tenta acessar a página de gerenciamento de turmas
        Then o sistema deve negar o acesso
        And exibir uma mensagem informando que a autenticação é necessária
