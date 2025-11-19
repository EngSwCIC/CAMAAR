Feature: Visualização de formulários não respondidos pelo participante
    Como Participante de uma turma
    Quero visualizar os formulários não respondidos das turmas em que estou matriculado
    A fim de poder escolher qual irei responder

    Background:
        Given que existe um participante autenticado
        And que o participante está matriculado em uma ou mais turmas

    Scenario: Visualizar formulários não respondidos com sucesso
        Given que existem formulários disponíveis e não respondidos nas turmas do participante
        When o participante acessa a página de formulários pendentes
        Then o sistema deve exibir a lista de formulários não respondidos
        And cada formulário deve mostrar informações como nome, turma e prazo (se houver)
        And cada formulário deve apresentar uma opção para iniciar a resposta

    Scenario: Não há formulários pendentes
        Given que o participante já respondeu todos os formulários disponíveis nas turmas em que está matriculado
        When o participante acessa a página de formulários pendentes
        Then o sistema deve informar que não existem formulários pendentes de resposta

    Scenario: Participante tenta acessar página sem estar autenticado
        Given que o usuário não está autenticado
        When o usuário tenta acessar a página de formulários pendentes
        Then o sistema deve negar o acesso
        And exibir uma mensagem informando que a autenticação é necessária

    Scenario: Erro ao carregar formulários pendentes
        Given que existe um problema temporário no carregamento das informações
        When o participante acessa a página de formulários pendentes
        Then o sistema deve exibir uma mensagem de erro
        And instruir o usuário a tentar novamente mais tarde