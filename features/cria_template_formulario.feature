# language: pt
@testes
@admim
@cria_template

Funcionalidade: Criação de Template de Formulário #102
    Eu como Administrador
    Quero criar um template de formulário contendo as questões do formulário
    A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

    Contexto:
        Dado que um 'administrador' está logado
        E está na tela de 'Criação de Template'
        E o banco de dados está 'carregado'

    @102.1
    Cenário: 102.1 - Quando um administrador preenche os dados e adiciona questões, deve salvar o novo template.
        Quando o título do template é preenchido 'corretamente'
        E são adicionadas as 'questões' ao formulário
        E o botão de 'salvar' é selecionado
        Entao o template deve ser armazenado no banco de dados
        E deve exibir uma mensagem de 'sucesso'

    @102.2
    Cenário: 102.2 - Quando um administrador tenta salvar um template sem questões, não deve permitir a criação.
        Quando o título do template é preenchido
        Mas não existe nenhuma 'questão' adicionada à lista
        E o botão de 'salvar' é selecionado
        Entao não deve gravar o novo 'template' no banco de dados
        E deve exibir um alerta de 'insira ao menos uma questão'

    @102.3
    Cenário: 102.3 - Quando um administrador cancela a criação, os dados não devem ser persistidos.
        Quando os campos do template estão 'preenchidos'
        Mas o botão de 'cancelar' é selecionado
        Entao os dados não devem ser salvos no banco de dados
        E deve redirecionar para a tela de 'templates'

    @102.4
    Cenário: 102.4 - Quando um administrador tenta criar um template com nome duplicado, deve ser impedido.
        Quando tenta salvar um template com um 'nome' que já existe no banco
        Entao não deve sobrescrever o 'template' existente
        E deve notificar que o 'nome' já está em uso

    @102.5
    Cenário: 102.5 - Quando um administrador tenta salvar um template, mas o banco de dados apresenta falha, não deve salvar os dados.
        Quando o título do template é preenchido 'corretamente'
        E o botão de 'salvar' é selecionado
        Mas a conexão com o banco de dados está 'falhando'
        Entao não deve gravar o novo 'template' no banco de dados
        E deve mostrar mensagem de erro de 'banco_de_dados'
