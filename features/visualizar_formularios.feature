Feature: Visualização de formulários criados
    Como Administrador
    Quero visualizar os formulários criados
    A fim de poder gerar um relatório a partir das respostas

    Background:
        Given que existe um administrador autenticado

    Scenario: Visualizar lista de formulários com sucesso
        Given que existem formulários cadastrados no sistema
        When o administrador acessa a página de formulários
        Then o sistema deve exibir a lista de formulários existentes
        And cada formulário deve exibir informações como nome, turma e data de criação
        And cada formulário deve apresentar uma opção para gerar relatório

    Scenario: Visualizar lista de formulários vazia
        Given que não existem formulários cadastrados no sistema
        When o administrador acessa a página de formulários
        Then o sistema deve informar que não há formulários disponíveis

    Scenario: Acessar detalhes de um formulário específico
        Given que existe ao menos um formulário cadastrado
        When o administrador seleciona um formulário na lista
        Then o sistema deve exibir as informações completas do formulário
        And deve disponibilizar uma opção para gerar o relatório a partir das respostas

    Scenario: Tentar acessar lista de formulários sem estar autenticado
        Given que o usuário não está autenticado como administrador
        When ele tenta acessar a página de formulários
        Then o sistema deve negar o acesso
        And exibir uma mensagem informando que a autenticação é necessária