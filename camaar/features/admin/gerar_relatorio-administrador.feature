# language: pt

Funcionalidade: Gerar relatório do administrador 
    Eu como Administrador
    Quero baixar um arquivo csv contendo os resultados de um formulário
    A fim de avaliar o desempenho das turmas

    # Happy Path
    Cenário: Existe ao menos um form respondido
        Dado que eu estou na pagina de admin
        E existe ao menos um form respondido
        E eu escolho o formulário que desejo 
        Então a página de resultados deve ser liberada 
        E eu clico em Gerar relatório 
        Então deve ser baixado um arquivo CSV com todas as respostas do formulário
        E devo avaliar o desempenho da turma

    # Sad Path
    Cenário: Não existe formulário
        Dado que eu estou na pagina de admin
        E não existe nenhum formulário respondido
        Então a pagina de de resultados não é liberada
        E deve ser exibida uma mensagem de que não é possivel gerar relatorio 