# language: pt

Funcionalidade: Visualizar os templates criados
    Eu como Administrador
    Quero baixar um arquivo csv contendo os resultados de um formulário
    A fim de avaliar o desempenho das turmas

    # Happy Path
    Cenário: Baixar CSVs de formulários selecionados
        Dado que eu estou logado no sistema com um usuário do tipo admin
        E estou na janela sobreposta de resultados
        Quando eu clico em "Gerar CSVs"
        Então deve ser baixado um arquivo ZIP contendo os resultados dos formulários selecionados

    # Sad Path
    Cenário: Nenhum formulário disponível
        Dado que eu estou logado no sistema com um usuário do tipo admin
        E estou na janela sobreposta de resultados
        E não há nenhuma turma disponível
        Então deve aparecer uma mensagem dizendo "Não existem resultados para baixar"