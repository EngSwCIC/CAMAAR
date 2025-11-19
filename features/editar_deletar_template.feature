Feature: Edição e exclusão de templates
    Como Administrador
    Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
    A fim de organizar os templates existentes

    Background:
        Given que existe um administrador autenticado
        And que existe um template previamente criado pelo administrador

    Scenario: Editar um template com sucesso
        When o administrador acessa a lista de templates
        And seleciona a opção de editar um template existente
        And realiza alterações válidas no template
        And confirma a edição
        Then o sistema deve salvar o template atualizado
        And os formulários já criados a partir desse template não devem ser alterados
        And o sistema deve exibir uma mensagem de sucesso

    Scenario: Editar um template com dados inválidos
        When o administrador tenta editar um template
        And insere informações inválidas ou incompletas
        Then o sistema deve impedir a edição
        And exibir uma mensagem de erro indicando o problema

    Scenario: Deletar um template com sucesso
        When o administrador acessa a lista de templates
        And seleciona a opção de deletar um template existente
        And confirma a exclusão do template
        Then o sistema deve remover o template da lista
        And os formulários já criados a partir do template removido devem permanecer intactos
        And o sistema deve exibir uma mensagem de sucesso
