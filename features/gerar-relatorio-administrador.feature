# language: pt

Funcionalidade: Visualizar os templates criados
    Eu como Administrador
    Quero baixar um arquivo csv contendo os resultados de um formulário
    A fim de avaliar o desempenho das turmas

    # Happy Path
    Cenário: Baixar CSV de formulários selecionados
        Dado que eu estou logado no sistema com um usuário do tipo admin
        E estou na janela sobreposta de resultados
        E há uma turma selecionada
        Quando eu clico em "Gerar resultado"
        Então deve ser baixado um arquivo CSV com os resultados do formulário

    # Sad Path
    Cenário: Nenhum formulário selecionado
        Dado que eu estou logado no sistema com um usuário do tipo admin
        E estou na janela sobreposta de resultados
        E não há uma turma selecionada
        Quando eu clico em "Gerar resultado"
        Então deve aparecer uma mensagem dizendo "Não existe formulário selecionado"