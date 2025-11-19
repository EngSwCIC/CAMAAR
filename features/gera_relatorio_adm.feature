# language: pt
@testes
@admim
@download_csv

Funcionalidade: Download de resultados em CSV #101
    Eu como Administrador
    Quero baixar um arquivo csv contendo os resultados de um formulário
    A fim de avaliar o desempenho das turmas

    Contexto:
        Dado que um 'administrador' está logado
        E está na tela 'Resultados do Formulário'
        E o banco de dados está 'carregado'
    
    @101.1
    Cenário: 101.1 - Quando um administrador aperta o botão de exportar, deve ser possível baixar o arquivo CSV.
        Quando o botão de 'exportar para CSV' é apertado
        Entao deve iniciar o download do arquivo
        E o arquivo deve estar no formato 'csv'
        E o arquivo deve conter os 'resultados' das turmas corretamente

    @101.2
    Cenário: 101.2 - Se o formulario não estiver preenchido, não deve ser possível fazer o download do CSV.
        Quando o formulário selecionado não possui 'respostas' salvas
        E o botão de 'exportar para CSV' é selecionado
        Entao deve exibir um alerta de 'sem dados disponíveis'
        E o download não deve ser realizado

    @101.3
    Cenário: 101.3 - Quando ocorrer uma falha no banco de dados durante a geração do arquivo, o download não deve ocorrer.
        Quando o botão de 'exportar para CSV' é selecionado
        E ocorre uma falha de 'conexão' com o servidor
        Entao deve exibir uma mensagem de 'erro' ao administrador
        E não deve gerar o arquivo 'csv'
