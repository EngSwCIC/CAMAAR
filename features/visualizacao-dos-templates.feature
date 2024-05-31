# language: pt

Funcionalidade: Visualizar os templates criados
    Eu como Administrador
    Quero visualizar os templates criados
    A fim de poder editar e/ou deletar um template que eu criei

    # Happy Path
    Cenário: Visualizar templates existentes
        Dado que eu estou logado no sistema com um usuário do tipo admin
        E estou na página do Administrador
        Quando eu clico em "Visualizar Templates"
        Então devem aparecer os templates criados na tela principal

    # Sad Path
    Cenário: Não há templates existentes
        Dado que eu estou logado no sistema com um usuário do tipo admin
        E estou na página do Administrador
        Quando eu clico em "Visualizar Templates"
        Mas há ausência de templates criados
        Então deve aparecer uma mensagem dizendo "Não existem templates criados" na tela principal