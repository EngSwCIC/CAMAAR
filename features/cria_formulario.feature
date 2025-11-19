# language: pt
@testes
@admim
@cria_form


Funcionalidade: Criar formulário de avaliação #103
    Eu como Administrador
    Quero criar um formulário baseado em um template para as turmas que eu escolher
    A fim de avaliar o desempenho das turmas no semestre atual

    Contexto:
        Dado que um 'administrador' está logado
        E está na tela 'Templates'
        E o banco de dados está 'carregado'

    @103.1
    Cenário: 103.1 - Quando um administrador tenta criar um formulário, com templates carregados no banco de dados, e ele preenche todos os campos corretamente, deve criar um formulário com sucesso.
        Quando um template é selecionado
        E os dados do formulário são preenchidos 'corretamente'
        Entao deve mostrar a mensagem 'formulario_criado'
        E o formulário deve estar salvo no banco de dados

    @103.2
    Cenário: 103.2 - Quando um administrador tenta criar um formulário, com templates carregados no banco de dados, e ele preenche os campos com erros, deve criar uma mensagem de erro e não deve descartar o formulário.
        Quando um template é selecionado
        E os dados do formulário são preenchidos 'incorretamente'
        Entao deve mostrar a mensagem de erro 'dados_incorreto'
        E ficar na tela 'criacao_formulario'
        E o banco de dados não deve ter 'formulário' salvo

    @103.3 
    Cenário: 103.3 - Sem templates salvos no banco de dados, não deve ser possível criar um formulário
        Quando o banco de dados não tem 'template' salvo
        E está na tela 'Gerenciamento'
        E tenta selecionar um formulário
        Entao deve permanecer na tela 'Gerenciamento'

   