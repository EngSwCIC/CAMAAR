# language: pt
@testes
@participante
@visualiza_formularios

Funcionalidade: Visualização de formulários pendentes #109
    Eu como Participante de uma turma
    Quero visualizar os formulários não respondidos das turmas em que estou matriculado
    A fim de poder escolher qual irei responder

    Contexto:
        Dado que um 'participante' está logado
        E está na tela 'Principal'
        E o banco de dados está 'carregado'

    @109.1
    Cenário: 109.1 - Quando o participante acessa o sistema, deve visualizar os formulários que ainda não respondeu.
        Quando o participante possui matrículas em 'turmas' ativas
        E existem formulários 'pendentes' vinculados a essas turmas
        Entao deve ser possível visualizar uma lista com os formulários 'não respondidos'
        E deve mostrar a qual 'turma' cada formulário pertence

    @109.2
    Cenário: 109.2 - Quando um participante seleciona um formulário da lista, deve ser direcionado para respondê-lo.
        Quando um formulário 'não respondido' é selecionado na lista
        Entao deve redirecionar para a tela de 'preenchimento' do formulário
        E o formulário deve estar habilitado para 'edição'

    @109.3
    Cenário: 109.3 - Quando o participante já respondeu tudo, não deve listar formulários pendentes.
        Quando o participante já enviou as respostas de 'todos' os formulários disponíveis
        Entao a lista de formulários 'pendentes' deve estar vazia
        E deve exibir uma mensagem de 'nenhuma atividade pendente'

    @109.4
    Cenário: 109.4 - O participante não deve visualizar formulários de turmas nas quais não está matriculado.
        Quando existem formulários abertos de 'outras turmas'
        Mas o participante não possui 'matrícula' nessas turmas
        Entao esses formulários não devem aparecer na lista de 'pendentes'

    @109.5
    Cenário: 109.5 - Quando não existem formulários criados para as turmas do participante, a lista deve estar vazia.
        Quando o participante está matriculado em 'turmas'
        Mas ainda não foram criados 'formulários' para essas turmas
        Entao a lista de formulários 'pendentes' deve estar vazia
        E deve exibir uma mensagem de 'sem formulários disponíveis'

    @109.6
    Cenário: 109.6 - Quando o participante tenta visualizar os formulários, mas o banco de dados apresenta falha, deve exibir erro.
        Quando o participante tenta carregar a lista de 'pendentes'
        Mas a conexão com o banco de dados está 'falhando'
        Entao não deve exibir a lista de 'formulários'
        E deve mostrar mensagem de erro de 'banco_de_dados'
