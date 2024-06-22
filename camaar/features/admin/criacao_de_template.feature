# language: pt

Funcionalidade: Criar templates
    Eu como Administrador
    Quero criar um template de formulário contendo as questões do formulário
    A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

    #Happy Path
    Cenário: Criando template
        Dado que estou na pagina do admin
        Quando eu clicar em criar templates
        Então deve aparecer um formulario que permite eu escolher que tipo de perguntas quero fazer
        E escrever as perguntas
        E escolher multiplas escolhas
        Quando clicar finalizar template
        Então devo ser redirecionado para a tela inicial
        E aparecer uma mensagem de template criado com sucesso

    # Sad Path
    Cenário: Erro ao criar template 
        Dado que estou na pagina do admin
        Quando eu clico em criar template
        E escrevo as perguntas
        E escolho as questões de multiplas escolhas
        Quando clicar finalizar template
        Então deve aparecer uma mensagem informando que houve problema durante a criação do formulario