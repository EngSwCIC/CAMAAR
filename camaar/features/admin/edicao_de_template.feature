# language: pt

Funcionalidade: Edição e deleção de templates
    Eu como Administrador
    Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
    A fim de organizar os templates existentes

    # Happy Path
    Cenário: Editar os templates já existentes
        Dado que eu estou na pagina inicial
        Quando eu clico no botao gerenciar
        E eu clico no botão editar templates
        Então devo ser redirecionado para a pagina de ediçao de templates

    # Sad Path
    Cenário: Não existe templates para editar
        Dado que eu estou na pagina inicial
        Quando eu clico no botao gerenciar
        E eu clico no botão editar templates
        E não existe templates
        Então deve aparecer uma mensagem de erro informando que não existe template para ser editado
        
    # Sad Path
    Cenario:  Não existe templates para excluir
        Dado que eu estou na pagina inicial
        Quando eu clico no botao gerenciar
        E eu clico no botão excluir templates
        E não existe templates
        Então deve aparecer uma mensagem de erro informando que não existe template para ser excluido