# language: pt

Funcionalidade: Ver os templates existentes
    Eu como Administrador
    Quero visualizar os templates criados
    A fim de poder editar e/ou deletar um template que eu criei

    # Happy Path
    Cenário: Ver todos os templates existentes
        Dado que estou na pagina do admin
        Quando eu clico em ver templates existentes
        Então deve aparecer os templates existentes

    # Sad Path
    Cenário: Ver todos os templates existentes
        Dado que estou na pagina do admin
        Quando eu clico em ver templates existentes
        Então deve aparecer uma mensagem dizendo que não existe templates